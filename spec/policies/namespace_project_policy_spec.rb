# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NamespaceProjectPolicy do
  subject { described_class.new(current_user, namespace_project) }

  let(:current_user) { create(:user) }
  let(:namespace_project) { create(:namespace_project) }

  context 'when user can create projects in namespace' do
    before do
      stub_allowed_ability(
        NamespacePolicy,
        :create_namespace_project,
        user: current_user,
        subject: namespace_project.namespace
      )
    end

    it { is_expected.to be_allowed(:read_namespace_project) }
  end
end
