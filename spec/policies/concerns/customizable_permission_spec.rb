# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CustomizablePermission do
  subject { policy_class.new(create_authentication(current_user), namespace) }

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

  context 'when role is assigned to projects' do
    subject { policy_class.new(create_authentication(current_user), project) }

    let(:policy_class) do
      Class.new(BasePolicy) do
        include CustomizablePermission

        namespace_resolver(&:namespace)

        customizable_permission :update_namespace_project
      end
    end
    let(:project) { create(:namespace_project, namespace: namespace) }

    before do
      create(:namespace_role_project_assignment, role: namespace_role, project: assigned_project)
      create(:namespace_role_ability, namespace_role: namespace_role, ability: :update_namespace_project)
    end

    context 'when checking on the assigned project' do
      let(:assigned_project) { project }

      it { is_expected.to be_allowed(:update_namespace_project) }
    end

    context 'when checking on another project' do
      let(:assigned_project) { create(:namespace_project, namespace: namespace) }

      it { is_expected.not_to be_allowed(:update_namespace_project) }
    end
  end

  it { is_expected.not_to be_allowed(:create_namespace_role) }
end
