# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Files::UploadService do
  subject(:service_response) { described_class.new(create_authentication(current_user), **params).execute }

  let(:current_user) do
    create(:user)
  end

  let(:file) { fixture_file_upload(Rails.root.join('spec/fixtures/square_image.webp'), 'image/webp') }

  shared_examples 'does not create' do
    it { is_expected.to be_error }

    it { expect { service_response }.not_to change { current_user&.avatar&.attached? } }
    it { expect { service_response }.not_to change { ActiveStorage::Attachment.count } }
  end

  context 'when user does not exist' do
    let(:current_user) { nil }
    let(:params) do
      { object: nil, attachment: file, attachment_name: 'avatar' }
    end

    it_behaves_like 'does not create'
  end

  context 'when params are invalid' do
    let(:current_user) { create(:user) }

    context 'when attachment name doesnt exists' do
      let(:params) do
        { object: current_user, attachment: file, attachment_name: 'asdasd' }
      end

      it_behaves_like 'does not create'
    end

    context 'when attachment is nil' do
      let(:params) do
        { object: current_user, attachment: nil, attachment_name: 'avatar' }
      end

      it_behaves_like 'does not create'
    end
  end

  context 'when user and params are valid' do
    let(:current_user) { create(:user) }
    let(:params) do
      { object: current_user, attachment: file, attachment_name: 'avatar' }
    end

    it { is_expected.to be_success }
    it { expect(service_response.payload.reload).to be_valid }

    it do
      expect(current_user.avatar.attached?).to be(false)
    end
  end
end
