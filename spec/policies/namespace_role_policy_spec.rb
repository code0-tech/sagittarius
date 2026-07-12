# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NamespaceRolePolicy do
  subject { described_class.new(create_authentication(current_user), namespace_role) }

  let(:current_user) { create(:user) }
  let(:namespace_role) { create(:namespace_role) }

  context 'when role is the personal namespace owner administrator role' do
    let(:namespace) { current_user.ensure_namespace }
    let(:namespace_role) do
      namespace.namespace_members.find_by(user: current_user).roles
               .joins(:abilities)
               .find_by(namespace_role_abilities: { ability: :namespace_administrator })
    end

    it { is_expected.not_to be_allowed(:delete_namespace_role) }
    it { is_expected.not_to be_allowed(:assign_role_abilities) }
    it { is_expected.not_to be_allowed(:assign_role_projects) }
  end
end
