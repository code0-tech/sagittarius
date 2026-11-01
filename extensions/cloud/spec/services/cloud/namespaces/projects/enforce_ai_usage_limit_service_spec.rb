# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Namespaces::Projects::EnforceAiUsageLimitService do
  include ActiveSupport::Testing::TimeHelpers

  subject(:service_response) { described_class.new(project).execute }

  let(:namespace) { create(:namespace) }
  let(:project) { create(:namespace_project, namespace: namespace) }

  def record_usage(for_project, tokens, date: Date.current)
    AiUsageDailyAggregate.record_generation!(
      project_id: for_project.id, namespace_id: for_project.namespace_id, flow_id: AiUsageDailyAggregate::NO_FLOW,
      usage: tokens, date: date, unique_by: %i[project_id flow_id date]
    )
  end

  it { expect(described_class).to include_module(CLOUD::Namespaces::Projects::EnforceAiUsageLimitService) }

  context 'without a namespace license' do
    it 'defaults to a limit of 25000, anchored to the namespace creation date' do
      travel_to(namespace.created_at + 10.days) { record_usage(project, 24_999) }

      response = travel_to(namespace.created_at + 10.days) { service_response }

      expect(response).to be_success
    end

    it 'blocks once usage reaches 25000 for the cycle' do
      travel_to(namespace.created_at + 10.days) { record_usage(project, 25_000) }

      travel_to(namespace.created_at + 10.days) { expect(service_response).to be_error }
    end

    it 'only counts usage within the same namespace' do
      other_namespace_project = create(:namespace_project)
      record_usage(other_namespace_project, 25_000)

      expect(service_response).to be_success
    end
  end

  context 'with a namespace license restricting ai_tokens' do
    before do
      create(:license, namespace: namespace, start_date: Date.new(2026, 1, 15), restrictions: { ai_tokens: 100 })
    end

    it 'uses the license limit instead of the unlicensed default of 25000' do
      travel_to(Date.new(2026, 9, 16)) { record_usage(project, 100) }

      travel_to(Date.new(2026, 9, 16)) do
        expect(service_response).to be_error
        expect(service_response.message).to include('Resets on 2026-10-15')
      end
    end

    it 'does not block while usage is within the licensed limit' do
      travel_to(Date.new(2026, 9, 16)) { record_usage(project, 99) }

      travel_to(Date.new(2026, 9, 16)) { expect(service_response).to be_success }
    end
  end
end
