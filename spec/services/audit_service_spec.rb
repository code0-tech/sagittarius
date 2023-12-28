# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AuditService do
  describe '.audit' do
    let(:user) { create(:user) }

    context 'when missing some keys' do
      let(:payload) do
        {
          author_id: user.id,
          entity_id: user.id,
        }
      end

      it 'raises an error' do
        expect do
          described_class.audit(:user_registered, payload)
        end.to raise_error(described_class::InvalidAuditEvent,
                           'Audit Event is missing the [:entity_type, :details, :target_id, :target_type] attributes')
      end
    end

    context 'with entity attribute' do
      let(:payload) do
        {
          author_id: user.id,
          entity: user,
          details: {},
          target_id: user.id,
          target_type: 'User',
        }
      end

      it 'expands to entity_id and entity_type', :aggregate_failures do
        event = described_class.audit(:user_registered, payload)
        expect(event.entity_id).to eq(user.id)
        expect(event.entity_type).to eq('User')
      end
    end

    context 'with target attribute' do
      let(:payload) do
        {
          author_id: user.id,
          entity_id: user.id,
          entity_type: 'User',
          details: {},
          target: user,
        }
      end

      it 'expands to target_id and target_type', :aggregate_failures do
        event = described_class.audit(:user_registered, payload)
        expect(event.target_id).to eq(user.id)
        expect(event.target_type).to eq('User')
      end
    end
  end
end
