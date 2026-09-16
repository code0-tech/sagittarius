# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Namespaces::Projects::EnforceAiUsageLimitService do
  include ActiveSupport::Testing::TimeHelpers

  # Both the ee and cloud extensions are active in this test environment, and Cloud overrides
  # every hook this service exposes (license/limit/cycle_anchor/scope). Exercising the real
  # `Namespaces::Projects::EnforceAiUsageLimitService` here would test Cloud's behavior, not EE's
  # - so, same as the runtime-execution enforcement spec, build an isolated class that only has
  # EE's module prepended, mirroring the core class's shape.
  subject(:service_response) { isolated_service_class.new(project).execute }

  let(:isolated_service_class) do
    Class.new do
      attr_reader :project

      def initialize(project)
        @project = project
      end

      def execute
        ServiceResponse.success(message: 'No AI usage limit enforcement configured')
      end

      prepend EE::Namespaces::Projects::EnforceAiUsageLimitService
    end
  end

  let(:project) { create(:namespace_project) }

  def record_usage(for_project, tokens, date: Date.current)
    AiUsageDailyAggregate.record_generation!(
      project_id: for_project.id, namespace_id: for_project.namespace_id, flow_id: AiUsageDailyAggregate::NO_FLOW,
      usage: tokens, date: date, unique_by: %i[project_id flow_id date]
    )
  end

  it { expect(described_class).to include_module(EE::Namespaces::Projects::EnforceAiUsageLimitService) }

  context 'without an active license' do
    it 'blocks the very first request (strict 0 limit)' do
      record_usage(project, 1)

      expect(service_response).to be_error
      expect(service_response.payload[:error_code]).to eq(:ai_usage_limit_exceeded)
    end

    it 'blocks even a request with no prior usage at all' do
      expect(service_response).to be_error
    end
  end

  context 'with a license that has no ai_tokens restriction' do
    before { create(:license, restrictions: {}) }

    it 'never blocks, regardless of usage' do
      record_usage(project, 1_000_000)

      expect(service_response).to be_success
    end
  end

  context 'with a license restricting ai_tokens' do
    before { create(:license, start_date: Date.new(2026, 1, 15), restrictions: { ai_tokens: 100 }) }

    it 'does not block while usage is within the limit' do
      travel_to(Date.new(2026, 9, 16)) { record_usage(project, 99) }

      travel_to(Date.new(2026, 9, 16)) { expect(service_response).to be_success }
    end

    it 'blocks once usage reaches the limit, anchored to the license start_date cycle' do
      travel_to(Date.new(2026, 9, 16)) { record_usage(project, 100) }

      travel_to(Date.new(2026, 9, 16)) do
        expect(service_response).to be_error
        expect(service_response.message).to include('Resets on 2026-10-15')
      end
    end

    it 'does not count usage from a previous billing cycle' do
      travel_to(Date.new(2026, 8, 20)) { record_usage(project, 100) }

      travel_to(Date.new(2026, 9, 16)) { expect(service_response).to be_success }
    end

    it 'pools usage across every project in the installation, not just this one' do
      other_project = create(:namespace_project)
      travel_to(Date.new(2026, 9, 16)) { record_usage(other_project, 100) }

      travel_to(Date.new(2026, 9, 16)) { expect(service_response).to be_error }
    end
  end
end
