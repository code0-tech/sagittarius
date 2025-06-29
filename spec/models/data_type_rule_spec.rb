# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DataTypeRule do
  subject(:rule) { create(:data_type_rule) }

  describe 'associations' do
    it { is_expected.to belong_to(:data_type).inverse_of(:rules) }
  end

  describe 'validations' do
    it { is_expected.to allow_values(*described_class::VARIANTS.keys).for(:variant) }

    context 'when variant is contains_key' do
      before { rule.variant = :contains_key }

      context 'when validating config with DataTypeContainsKeyRuleConfig schema' do
        it 'is correct' do
          rule.config = {
            key: 'id',
            data_type_identifier: {
              data_type_identifier: 'User',
            },
          }
          is_expected.to be_valid
        end

        it 'when its incorrect' do
          rule.config = {
            data_type_identifier: {
              data_type_identifier: 'User',
            },
          }
          is_expected.not_to be_valid
        end
      end
    end

    context 'when variant is contains_type' do
      before { rule.variant = :contains_type }

      context 'when its correct' do
        it 'when validating config with DataTypeContainsTypeRuleConfig schema' do
          rule.config = {
            data_type_identifier: {
              data_type_identifier: 'User',
            },
          }
          is_expected.to be_valid
        end
      end

      context 'when its incorrect' do
        it 'when validating config with DataTypeContainsTypeRuleConfig schema' do
          rule.config = {
            key: 'id',
          }
          is_expected.not_to be_valid
        end
      end
    end

    context 'when variant is item_of_collection' do
      before { rule.variant = :item_of_collection }

      context 'when validating config with DataTypeItemOfCollectionRuleConfig schema' do
        it 'is correct' do
          rule.config = {
            items: [
              ['a', 1, true, { key: 'value' }],
              { test: 2 },
              []
            ],
          }
          is_expected.to be_valid
        end

        it 'when its incorrect' do
          rule.config = {
            key: 'id',
          }
          is_expected.not_to be_valid
        end
      end
    end

    context 'when variant is number_range' do
      before { rule.variant = :number_range }

      context 'when validating config with DataTypeNumberRangeRuleConfig schema' do
        it 'is correct' do
          rule.config = {
            from: 1,
            to: 10,
            steps: 1,
          }
          is_expected.to be_valid
        end

        it 'when its incorrect' do
          rule.config = {
            from: 'one',
            to: 10,
            steps: 1,
          }
          is_expected.not_to be_valid
        end
      end
    end

    context 'when variant is regex' do
      before { rule.variant = :regex }

      context 'when validating config with DataTypeRegexRuleConfig schema' do
        it 'is correct' do
          rule.config = {
            pattern: '.*',
          }
          is_expected.to be_valid
        end

        it 'when its incorrect' do
          rule.config = {
            pattern: 1234,
          }
          is_expected.not_to be_valid
        end
      end
    end
  end
end
