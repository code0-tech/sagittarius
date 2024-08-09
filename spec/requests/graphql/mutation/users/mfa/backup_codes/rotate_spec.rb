# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'usersMfaBackupCodesRotate Mutation' do
  include GraphqlHelpers

  subject(:mutate!) { post_graphql mutation, current_user: current_user }

  let(:mutation) do
    <<~QUERY
      mutation {
        usersMfaBackupCodesRotate(input: {}) {
          #{error_query}
          codes
        }
      }
    QUERY
  end

  let(:current_user) { create(:user) }

  context 'when user is valid' do
    let(:current_user) { create(:user) }

    it 'returns correct backup codes' do
      mutate!
      codes = graphql_data_at(:users_mfa_backup_codes_rotate, :codes)
      expect(codes).to be_present
      codes.each do |code|
        expect(BackupCode.where(token: code, user: current_user)).to be_exists
      end
    end
  end
end
