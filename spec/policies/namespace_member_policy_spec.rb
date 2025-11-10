# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NamespaceMemberPolicy do
  subject { described_class.new(create_authentication(current_user), namespace_member) }

  let(:current_user) { create(:user) }
  let(:namespace_member) { create(:namespace_member) }

  context 'when user does not have permission to delete member' do
    it { is_expected.not_to be_allowed(:delete_member) }

    context 'when member is the current user' do
      let(:namespace_member) { create(:namespace_member, user: current_user) }

      it { is_expected.to be_allowed(:delete_member) }
    end
  end
end
