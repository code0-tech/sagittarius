# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'StorageObjects' do
  include AuthenticationHelpers
  include ActiveSupport::Testing::TimeHelpers

  let(:current_user) { create(:user) }
  let(:namespace) { current_user.ensure_namespace }
  let(:project) { create(:namespace_project, namespace: namespace) }
  let(:file) { fixture_file_upload(Rails.root.join('spec/fixtures/square_image.webp'), 'image/webp') }

  def auth_header
    { Authorization: "Session #{authorization_token(current_user)}" }
  end

  describe 'POST /storage_objects/upload' do
    it 'rejects unauthenticated requests' do
      post '/storage_objects/upload', params: { attachment: file }
      expect(response).to have_http_status(:unauthorized)
      expect(response.parsed_body).to include('message', 'error_code')
    end

    it 'stores the file for a user (GlobalID project) and returns the file metadata' do
      post '/storage_objects/upload', params: {
        attachment: file,
        project_id: SagittariusSchema.id_from_object(project),
      }, headers: auth_header

      expect(response).to have_http_status(:ok)
      body = response.parsed_body
      expect(body.keys).to contain_exactly('id', 'file_name', 'content_type', 'byte_size', 'checksum', 'expires_at')
      expect(body['file_name']).to eq('square_image.webp')
      expect(body['checksum']).to start_with('sha256:')

      storage_object = StorageObject.find(body['id'])
      expect(storage_object).to be_status_committed
      expect(storage_object).to be_origin_user_upload
      expect(storage_object.project).to eq(project)
      expect(storage_object.expires_at).to be_nil
    end

    it 'accepts a plain integer project id' do
      post '/storage_objects/upload', params: { attachment: file, project_id: project.id }, headers: auth_header

      expect(response).to have_http_status(:ok)
    end

    it 'fails when the project is missing' do
      post '/storage_objects/upload', params: { attachment: file }, headers: auth_header

      expect(response).to have_http_status(:bad_request)
      expect(response.parsed_body['error_code']).to eq('missing_parameter')
    end

    it 'answers identically for a project the user cannot access and a non-existent one' do
      other_project = create(:namespace_project)

      post '/storage_objects/upload', params: { attachment: file, project_id: other_project.id }, headers: auth_header
      forbidden = [response.status, response.parsed_body]
      post '/storage_objects/upload', params: { attachment: file, project_id: 0 }, headers: auth_header

      expect(forbidden).to eq([404, { 'message' => 'Project not found', 'error_code' => 'project_not_found' }])
      expect([response.status, response.parsed_body]).to eq(forbidden)
    end

    it 'rejects an attachment that is not an uploaded file' do
      post '/storage_objects/upload', params: { attachment: 'text', project_id: project.id }, headers: auth_header

      expect(response).to have_http_status(:bad_request)
      expect(response.parsed_body['error_code']).to eq('invalid_attachment')
    end

    describe 'expires_at' do
      it 'parses epoch milliseconds' do
        expires_ms = (1.hour.from_now.to_f * 1000).to_i

        post '/storage_objects/upload', params: { attachment: file, project_id: project.id, expires_at: expires_ms },
                                        headers: auth_header

        expect(response).to have_http_status(:ok)
        expect(StorageObject.find(response.parsed_body['id']).expires_at).to be_within(0.001)
          .of(Time.zone.at(expires_ms.fdiv(1000)))
      end

      it 'rejects values that are not epoch milliseconds' do
        post '/storage_objects/upload', params: { attachment: file, project_id: project.id, expires_at: 'tomorrow' },
                                        headers: auth_header

        expect(response).to have_http_status(:bad_request)
        expect(response.parsed_body['error_code']).to eq('invalid_expires_at')
      end
    end

    describe 'with a runtime token' do
      let(:runtime) { create(:runtime, namespace: namespace) }

      it 'is not accepted: runtimes upload through signed urls only' do
        create(:namespace_project_runtime_assignment, runtime: runtime, namespace_project: project)

        post '/storage_objects/upload', params: { attachment: file, project_id: project.id },
                                        headers: { Authorization: "Bearer #{runtime.token}" }

        expect(response).to have_http_status(:unauthorized)
        expect(StorageObject.count).to eq(0)
      end
    end
  end

  describe 'PUT /storage_objects/upload' do
    let(:storage_object) do
      create(:storage_object, project: project, file_name: 'data.txt', content_type: 'text/plain', byte_size: 0,
                              checksum: nil, origin: :execution_output, created_by: nil)
    end
    let(:signature) { StorageObjects::SignedUrl.encode_upload(storage_object).token }
    let(:content) { 'hello signed upload' }

    def put_upload(signature: self.signature, body: content)
      put "/storage_objects/upload?#{{ signature: signature }.to_query}",
          headers: { 'CONTENT_TYPE' => 'application/octet-stream' },
          env: { 'rack.input' => StringIO.new(body), 'CONTENT_LENGTH' => body.bytesize.to_s }
    end

    it 'commits the pending object with the raw body without an Authorization header' do
      put_upload

      expect(response).to have_http_status(:ok)
      expect(response.parsed_body).to eq(
        'id' => storage_object.id, 'file_name' => 'data.txt', 'content_type' => 'text/plain',
        'byte_size' => content.bytesize, 'checksum' => "sha256:#{Digest::SHA256.hexdigest(content)}",
        'expires_at' => nil
      )

      storage_object.reload
      expect(storage_object).to be_status_committed
      expect(storage_object.blob.download).to eq(content)
      expect(storage_object.blob.content_type).to eq('text/plain') # request Content-Type is ignored
    end

    it 'returns the expiry as epoch milliseconds' do
      storage_object.update!(expires_at: 1.day.from_now.change(usec: 0))

      put_upload

      expect(response.parsed_body['expires_at']).to eq(storage_object.expires_at.to_i * 1000)
    end

    it 'is single-use' do
      put_upload
      expect(response).to have_http_status(:ok)

      put_upload(body: 'other')
      expect(response).to have_http_status(:not_found)
      expect(storage_object.reload.blob.download).to eq(content)
    end

    it 'rejects an expired token' do
      token = signature
      travel_to(16.minutes.from_now) { put_upload(signature: token) }

      expect(response).to have_http_status(:not_found)
      expect(storage_object.reload).to be_status_pending
    end

    it 'rejects an unknown or missing token' do
      put_upload(signature: 'nope')
      expect(response).to have_http_status(:not_found)

      put '/storage_objects/upload'
      expect(response).to have_http_status(:not_found)
    end

    it 'rejects a download token' do
      committed = create(:storage_object, :committed, project: project)
      put_upload(signature: StorageObjects::SignedUrl.encode_download(committed).token)

      expect(response).to have_http_status(:not_found)
    end

    it 'rejects an upload token for an already committed object' do
      token = signature
      storage_object.update!(status: :committed)
      put_upload(signature: token)

      expect(response).to have_http_status(:not_found)
    end

    it 'rejects a body above the namespace file size limit' do
      namespace.update!(max_file_size_bytes: 3)
      put_upload

      expect(response).to have_http_status(:content_too_large)
      expect(response.parsed_body['error_code']).to eq('file_too_large')
      expect(storage_object.reload).to be_status_pending
    end

    it 'rejects a body that exceeds the namespace quota' do
      namespace.update!(storage_quota_bytes: 3)
      put_upload

      expect(response).to have_http_status(:content_too_large)
      expect(response.parsed_body['error_code']).to eq('quota_exceeded')
      expect(storage_object.reload).to be_status_pending
    end

    it 'cannot be used with the multipart POST contract' do
      post '/storage_objects/upload', params: { signature: signature }
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'GET /storage_objects/download' do
    let(:storage_object) { create(:storage_object, :committed, project: project) }

    it 'streams the bytes for a valid signature' do
      signature = StorageObjects::SignedUrl.encode_download(storage_object).token
      get '/storage_objects/download', params: { signature: signature }

      expect(response).to have_http_status(:ok)
      expect(response.body).to eq('hello world')
      expect(response.headers['Content-Disposition']).to include('attachment')
      expect(response.headers['Content-Type']).to start_with('text/plain')
    end

    it 'returns 404 for an invalid signature' do
      get '/storage_objects/download', params: { signature: 'nope' }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'signed upload then download round-trip' do
    it 'serves back the uploaded bytes' do
      prepared = StorageObjects::PrepareUploadService.new(
        create_authentication(current_user), project: project, file_name: 'x.bin', content_type: 'application/x-bin'
      ).execute.payload

      put "/storage_objects/upload?#{{ signature: StorageObjects::SignedUrl.encode_upload(prepared).token }.to_query}",
          env: { 'rack.input' => StringIO.new('bytes!') }
      expect(response).to have_http_status(:ok)

      url = StorageObjects::SignedUrl.download_url(StorageObjects::SignedUrl.encode_download(prepared.reload).token)
      get URI.parse(url).request_uri
      expect(response).to have_http_status(:ok)
      expect(response.body).to eq('bytes!')
    end
  end
end
