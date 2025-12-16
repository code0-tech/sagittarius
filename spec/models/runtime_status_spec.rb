# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RuntimeStatus do
  subject(:runtime_status) { create(:runtime_status) }

  describe 'associations' do
    it { is_expected.to have_many(:runtime_status_configurations).inverse_of(:runtime_status) }
    it { is_expected.to belong_to(:runtime).inverse_of(:runtime_statuses) }
  end

  describe 'validations' do
    context 'when status information exist' do
      before do
        create(:runtime_status_configuration, runtime_status: runtime_status)
      end

      context 'when type is :adapter' do
        before { runtime_status.status_type = :adapter }

        it 'is valid' do
          expect(runtime_status).to be_valid
        end
      end

      context 'when type is :execution' do
        before { runtime_status.status_type = :execution }

        it 'is invalid' do
          expect(runtime_status).not_to be_valid
        end
      end
    end
  end
end
