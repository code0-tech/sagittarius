# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DataTypeRule do
  subject { create(:data_type_rule) }

  describe 'associations' do
    it { is_expected.to belong_to(:data_type).inverse_of(:rules) }
  end

  describe 'validations' do
    it { is_expected.to allow_values(*described_class::VARIANTS.keys).for(:variant) }

    context 'when variant is contains_key' do
      before { subject.variant = :contains_key }

      context 'validates config with DataTypeContainsKeyRuleConfig schema' do
        it 'is correct' do
          subject.config = {
            key: "id",
            data_type_identifier: {
              data_type_identifier: "User"
            }
          }
          expect(subject).to be_valid
        end
        it 'is incorrect' do
          subject.config = {
            data_type_identifier: {
              data_type_identifier: "User"
            }
          }
          expect(subject).not_to be_valid
        end
      end
    end
    context 'when variant is contains_type' do
      before { subject.variant = :contains_type }

      context 'is correct' do
        it 'validates config with DataTypeContainsTypeRuleConfig schema' do
          subject.config = {
            data_type_identifier: {
              data_type_identifier: "User"
            }
          }
          expect(subject).to be_valid
        end
      end
      context 'is incorrect' do
        it 'validates config with DataTypeContainsTypeRuleConfig schema' do
          subject.config = {
            key: "id"
          }
          expect(subject).not_to be_valid
        end
      end
    end
    context 'when variant is item_of_collection' do
      before { subject.variant = :item_of_collection }

      context 'validates config with DataTypeItemOfCollectionRuleConfig schema' do
        it 'is correct' do
          subject.config = {
            "items": [
              ["a", 1, true, {"key": "value"}],
              {"test": 2},
              []
            ]
          }
          expect(subject).to be_valid
        end
        it 'is incorrect' do
          subject.config = {
            key: "id"
          }
          expect(subject).not_to be_valid
        end
      end
    end
    context 'when variant is number_range' do
      before { subject.variant = :number_range }

      context 'validates config with DataTypeNumberRangeRuleConfig schema' do
        it 'is correct' do
          subject.config = {
            from: 1,
            to: 10,
            steps: 1
          }
          expect(subject).to be_valid
        end
        it 'is incorrect' do
          subject.config = {
            from: "one",
            to: 10,
            steps: 1
          }
          expect(subject).not_to be_valid
        end
      end
    end
    context 'when variant is regex' do
      before { subject.variant = :regex }

      context 'validates config with DataTypeRegexRuleConfig schema' do
        it 'is correct' do
          subject.config = {
            pattern: '.*'
          }
          expect(subject).to be_valid
        end
        it 'is incorrect' do
          subject.config = {
            pattern: 1234
          }
          expect(subject).not_to be_valid
        end
      end
    end
  end
end
