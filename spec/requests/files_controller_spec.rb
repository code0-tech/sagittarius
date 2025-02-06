# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FilesController do
  let(:current_user) do
    create(:user)
  end

  let(:file) { fixture_file_upload(Rails.root.join('spec/fixtures/square_image.webp'), 'image/webp') }

  it 'fails because of missing arguments' do
    post '/files/upload', headers: { Authorization: "Session #{authorization_token(current_user)}" }
    expect(response).to have_http_status(:bad_request)
    expect(ActiveStorage::Attachment.count).to eq(0)
  end

  it 'creates the attachment' do
    expect(current_user.avatar.attached?).to be(false)
    post '/files/upload', params: {
      attachment: file,
      id: SagittariusSchema.id_from_object(current_user),
      attachment_name: 'avatar',
    }, headers: { Authorization: "Session #{authorization_token(current_user)}" }

    current_user.reload
    expect(current_user.avatar.attached?).to be(true)
    expect(response).to have_http_status(:ok)
    expect(ActiveStorage::Attachment.where(record: current_user, name: 'avatar')).to be_present
  end

  def authorization_token(current_user)
    session = UserSession.find_by(user: current_user, active: true)
    session = create(:user_session, user: current_user) if session.nil?

    session.token
  end
end
