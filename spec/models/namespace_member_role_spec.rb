# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NamespaceMemberRole do
  subject { create(:namespace_member_role) }

  describe 'associations' do
    it { is_expected.to belong_to(:namespace_role).required.inverse_of(:namespace_member_roles) }
    it { is_expected.to belong_to(:namespace_member).required.inverse_of(:namespace_member_roles) }
  end
end
