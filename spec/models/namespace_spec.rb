# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Namespace do
  subject(:namespace) { create(:namespace, parent: parent) }

  let(:parent) { create(:organization) }

  describe 'associations' do
    it { is_expected.to belong_to(:parent).required }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:parent) }
  end

  describe '#organization_type?' do
    context 'when parent is organization' do
      it { expect(namespace.organization_type?).to be true }
    end

    context 'when parent is user' do
      let(:parent) { create(:user) }

      it { expect(namespace.organization_type?).to be false }
    end
  end
end
