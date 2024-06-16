# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CustomizablePermission do
  subject { policy_class.new(current_user, namespace) }

  let(:policy_class) do
    Class.new(BasePolicy) do
      include CustomizablePermission

      namespace_resolver { |namespace| namespace }

      customizable_permission :create_namespace_role
    end
  end
  let(:current_user) { create(:user) }
  let(:namespace) { create(:namespace) }
  let(:namespace_member) { create(:namespace_member, namespace: namespace, user: current_user) }
  let(:namespace_role) do
    create(:namespace_role, namespace: namespace).tap do |role|
      create(:namespace_member_role, member: namespace_member, role: role)
    end
  end

  context 'when user has a role with the administrator ability' do
    before do
      create(:namespace_role_ability, namespace_role: namespace_role, ability: :namespace_administrator)
    end

    it { is_expected.to be_allowed(:create_namespace_role) }
  end

  context 'when user has a role with the ability' do
    before do
      create(:namespace_role_ability, namespace_role: namespace_role, ability: :create_namespace_role)
    end

    it { is_expected.to be_allowed(:create_namespace_role) }
  end

  context 'when user has a role with a different ability' do
    before do
      create(:namespace_role_ability, namespace_role: namespace_role, ability: :create_namespace_role)
    end

    it { is_expected.not_to be_allowed(:invite_member) }
  end

  it { is_expected.not_to be_allowed(:create_namespace_role) }
end
