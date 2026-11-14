# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'usersMfaBackupCodesRotate Mutation' do
  include GraphqlHelpers

  subject(:mutate!) { post_graphql mutation, variables: variables, current_user: current_user }

  let(:mutation) do
    <<~QUERY
      mutation($input: UsersMfaBackupCodesRotateInput!) {
        usersMfaBackupCodesRotate(input: $input) {
          #{error_query}
          codes
        }
      }
    QUERY
  end

  let(:input) { {} }
  let(:variables) { { input: input } }
  let(:current_user) { create(:user) }

  context 'when mfa is not enabled' do
    it 'returns correct backup codes' do
      mutate!
      codes = graphql_data_at(:users_mfa_backup_codes_rotate, :codes)
      expect(codes).to be_present
      codes.each do |code|
        expect(BackupCode.where(token: code, user: current_user)).to be_exists
      end
    end
  end

  context 'when mfa is enabled' do
    let(:current_user) { create(:user, :mfa_totp) }

    context 'when a valid totp is provided' do
      let(:input) { { mfa: { type: 'TOTP', value: ROTP::TOTP.new(current_user.totp_secret).now } } }

      it 'returns correct backup codes' do
        mutate!
        codes = graphql_data_at(:users_mfa_backup_codes_rotate, :codes)
        expect(codes).to be_present
        codes.each do |code|
          expect(BackupCode.where(token: code, user: current_user)).to be_exists
        end
      end
    end

    context 'when no mfa is provided' do
      let(:input) { {} }

      it 'returns a mfa required error' do
        mutate!
        expect(graphql_data_at(:users_mfa_backup_codes_rotate, :codes)).to be_nil
        expect(graphql_data_at(:users_mfa_backup_codes_rotate, :errors, :error_code)).to include('MFA_REQUIRED')
      end
    end
  end
end
