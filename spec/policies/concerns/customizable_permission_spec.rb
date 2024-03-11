# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CustomizablePermission do
  subject { policy_class.new(current_user, organization) }

  let(:policy_class) do
    Class.new(BasePolicy) do
      include CustomizablePermission

      organization_resolver { |organization| organization }

      customizable_permission :create_organization_role
    end
  end
  let(:current_user) { create(:user) }
  let(:organization) { create(:organization) }
  let(:organization_member) { create(:organization_member, organization: organization, user: current_user) }
  let(:organization_role) do
    create(:organization_role, organization: organization).tap do |role|
      create(:organization_member_role, member: organization_member, role: role)
    end
  end

  context 'when user has a role with the ability' do
    before do
      create(:organization_role_ability, organization_role: organization_role, ability: :create_organization_role)
    end

    it { is_expected.to be_allowed(:create_organization_role) }
  end

  context 'when user has a role with a different ability' do
    before do
      create(:organization_role_ability, organization_role: organization_role, ability: :create_organization_role)
    end

    it { is_expected.not_to be_allowed(:invite_member) }
  end

  it { is_expected.not_to be_allowed(:create_organization_role) }
end
