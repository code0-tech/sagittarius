# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FileHandler do
  describe '#get_file_download_url' do
    let(:runtime) { create(:runtime) }
    let(:project) { create(:namespace_project) }
    let(:storage_object) { create(:storage_object, :committed, project: project) }

    def call(id: storage_object.id, project_id: project.id)
      request = Tucana::Sagittarius::Rails::GetFileDownloadUrlRequest.new(
        id: id, project_id: project_id, execution_identifier: 'exec-1'
      )

      Code0::ZeroTrack::Context.with_context(runtime: { id: runtime.id, namespace_id: nil }) do
        described_class.new.get_file_download_url(request, nil)
      end
    end

    context 'when the runtime is assigned to the project' do
      before { create(:namespace_project_runtime_assignment, runtime: runtime, namespace_project: project) }

      it 'returns a signed absolute download url, its expiry and the file metadata' do
        response = call

        expect(response.error).to be_nil
        expect(response.url).to start_with('http://localhost:8080/storage_objects/download?signature=')
        expect(response.url_expires_at).to be_within(5000).of((5.minutes.from_now.to_f * 1000).to_i)
        expect(response.file).to have_attributes(
          id: storage_object.id, file_name: 'file.txt', content_type: 'text/plain',
          byte_size: storage_object.byte_size, checksum: 'sha256:test'
        )

        signature = Rack::Utils.parse_query(URI.parse(response.url).query)['signature']
        expect(StorageObjects::SignedUrl.decode_download(signature)).to eq(storage_object)
      end

      it 'reports a file of another project as not found' do
        other = create(:storage_object, :committed)
        create(:namespace_project_runtime_assignment, runtime: runtime, namespace_project: other.project)

        response = call(id: other.id)

        expect(response.error.message).to eq('Storage object not found')
        expect(response.url).to be_empty
        expect(response.file).to be_nil
      end

      it 'reports an unknown id exactly like a foreign file' do
        expect(call(id: 0).error.message).to eq('Storage object not found')
      end

      it 'reports an expired file as not found' do
        storage_object.update!(expires_at: 1.minute.ago)

        expect(call.error.message).to eq('Storage object not found')
      end
    end

    context 'when the runtime is not assigned to the project' do
      it 'reports the file as not found' do
        response = call

        expect(response.error.message).to eq('Storage object not found')
        expect(response.url).to be_empty
      end
    end
  end

  describe '#get_file_upload_url' do
    let(:runtime) { create(:runtime) }
    let(:project) { create(:namespace_project) }
    let(:expires_at) { nil }

    def call(project_id: project.id, expires_at: self.expires_at, file_name: 'out.csv')
      attributes = { file_name: file_name, content_type: 'text/csv', project_id: project_id,
                     execution_identifier: 'exec-1' }
      attributes[:expires_at] = expires_at unless expires_at.nil?
      request = Tucana::Sagittarius::Rails::GetFileUploadUrlRequest.new(**attributes)

      Code0::ZeroTrack::Context.with_context(runtime: { id: runtime.id, namespace_id: nil }) do
        described_class.new.get_file_upload_url(request, nil)
      end
    end

    context 'when the runtime is assigned to the project' do
      before { create(:namespace_project_runtime_assignment, runtime: runtime, namespace_project: project) }

      it 'creates a pending object and returns a signed absolute upload url' do
        response = nil
        expect { response = call }.to change { StorageObject.status_pending.count }.by(1)

        expect(response.error).to be_nil
        expect(response.url).to start_with('http://localhost:8080/storage_objects/upload?signature=')
        expect(response.url_expires_at).to be_within(5000).of((15.minutes.from_now.to_f * 1000).to_i)

        storage_object = StorageObject.find(response.id)
        expect(storage_object).to have_attributes(
          status: 'pending', origin: 'execution_output', created_by: nil, project: project, file_name: 'out.csv',
          content_type: 'text/csv', execution_identifier: 'exec-1', expires_at: nil
        )

        signature = Rack::Utils.parse_query(URI.parse(response.url).query)['signature']
        expect(StorageObjects::SignedUrl.decode_upload(signature)).to eq(storage_object)
      end

      context 'with expires_at' do
        let(:expires_at) { (1.day.from_now.to_f * 1000).to_i }

        it 'stores the expiry' do
          expect(StorageObject.find(call.id).expires_at).to be_within(0.001).of(Time.zone.at(expires_at.fdiv(1000)))
        end
      end

      it 'rejects an expiry in the past' do
        response = nil
        expect { response = call(expires_at: (1.minute.ago.to_f * 1000).to_i) }
          .not_to(change { StorageObject.count })

        expect(response.error.message).to eq('expires_at must be in the future')
        expect(response.url).to be_empty
      end

      it 'reports an invalid file name' do
        expect(call(file_name: '').error.message).to eq('Storage object is invalid')
      end

      it 'reports an unknown project like a project without access' do
        expect(call(project_id: 0).error.message).to eq('Project not found')
      end
    end

    context 'when the runtime is not assigned to the project' do
      it 'reports the project as not found and creates nothing' do
        response = nil
        expect { response = call }.not_to(change { StorageObject.count })

        expect(response.error.message).to eq('Project not found')
        expect(response.url).to be_empty
      end
    end
  end
end
