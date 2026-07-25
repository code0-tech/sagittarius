# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Translation do
  subject(:translation) { create(:translation) }

  describe 'associations' do
    it { is_expected.to belong_to(:owner).required }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:code) }
    it { is_expected.to validate_presence_of(:content) }
  end

  describe 'polymorphic owner cleanup trigger' do
    it 'deletes translations when an owner is deleted directly in PostgreSQL' do
      owner = create(:data_type)
      translation = create(:translation, owner: owner)

      DataType.where(id: owner.id).delete_all

      expect(described_class).not_to exist(translation.id)
    end
  end

  describe '#to_grpc' do
    it 'matches the model' do
      grpc_object = translation.to_grpc

      expect(grpc_object.to_h).to eq(
        code: translation.code,
        content: translation.content
      )
    end
  end
end
