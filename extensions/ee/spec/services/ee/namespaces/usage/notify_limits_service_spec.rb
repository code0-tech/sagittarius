# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Namespaces::Usage::NotifyLimitsService do
  include ActiveSupport::Testing::TimeHelpers

  # Both the ee and cloud extensions are active in this test environment, and Cloud overrides
  # every hook this service exposes. Exercising the real `Namespaces::Usage::NotifyLimitsService`
  # here would test Cloud's behavior, not EE's - so, same as the enforcement specs, build an
  # isolated class that only has EE's module prepended, mirroring the core class's shape.
  subject(:service_response) { isolated_service_class.new(namespace: namespace).execute }

  let(:isolated_service_class) do
    Class.new do
      attr_reader :namespace

      def initialize(namespace:)
        @namespace = namespace
      end

      def execute
        ServiceResponse.success(message: 'No usage limit notifications configured')
      end

      prepend EE::Namespaces::Usage::NotifyLimitsService
    end
  end

  # EE's license - and therefore its usage pool - is installation-wide, so which namespace
  # happened to report the usage makes no difference here.
  let(:namespace) { create(:namespace) }
  let(:project) { create(:namespace_project) }
  let!(:administrator) { create(:user, admin: true) }

  let(:mailer) { instance_double(UsageLimitMailer) }
  let(:mail_message) { instance_double(ActionMailer::MessageDelivery, deliver_later: nil) }

  before do
    allow(UsageLimitMailer).to receive(:with).and_return(mailer)
    allow(mailer).to receive_messages(limit_reached: mail_message, limit_warning: mail_message)
  end

  def record_ai_usage(tokens, date: Date.current)
    AiUsageDailyAggregate.record_generation!(
      project_id: project.id, namespace_id: project.namespace_id, flow_id: AiUsageDailyAggregate::NO_FLOW,
      usage: tokens, date: date, unique_by: %i[project_id flow_id date]
    )
  end

  def record_workflow_usage(count, date: Date.current)
    flow = create(:flow, project: project)

    RuntimeUsageDailyAggregate.record_execution!(
      flow_id: flow.id, project_id: project.id, namespace_id: project.namespace_id,
      date: date, execution_time_us: 1, count: count, unique_by: %i[flow_id date]
    )
  end

  it { expect(described_class).to include_module(EE::Namespaces::Usage::NotifyLimitsService) }

  context 'without an active license' do
    it 'notifies nobody - there is no plan whose limits could be approached' do
      record_ai_usage(1_000)

      expect(service_response).to be_success
      expect(service_response.payload[:notified]).to be_empty
      expect(mailer).not_to have_received(:limit_reached)
      expect(mailer).not_to have_received(:limit_warning)
    end
  end

  context 'with a license that restricts nothing' do
    before { create(:license, restrictions: {}) }

    it 'notifies nobody, regardless of usage' do
      record_ai_usage(1_000_000)

      expect(service_response.payload[:notified]).to be_empty
      expect(mailer).not_to have_received(:limit_warning)
    end
  end

  context 'with a license restricting ai_tokens' do
    before do
      travel_to(Date.new(2026, 9, 20))
      create(:license, start_date: Date.new(2026, 1, 15), end_date: Date.new(2027, 1, 14),
                       restrictions: { ai_tokens: 100 })
    end

    it 'stays quiet while usage is comfortably within the limit' do
      record_ai_usage(79)

      expect(service_response.payload[:notified]).to be_empty
      expect(mailer).not_to have_received(:limit_warning)
    end

    it 'warns once the warning threshold is crossed' do
      record_ai_usage(80)

      expect(service_response.payload[:notified]).to eq([:warning])
      expect(mailer).to have_received(:limit_warning)
      expect(UsageLimitMailer).to have_received(:with).with(
        hash_including(
          user: administrator,
          affected_resources: 'AI tokens',
          threshold_percentage: 80,
          ai_usage: 80,
          ai_limit: 100
        )
      )
    end

    it 'reports the limit itself as reached, not as a warning' do
      record_ai_usage(100)

      expect(service_response.payload[:notified]).to eq([:reached])
      expect(mailer).to have_received(:limit_reached)
      expect(mailer).not_to have_received(:limit_warning)
    end

    it 'sends each notification only once per billing cycle' do
      record_ai_usage(80)

      2.times { isolated_service_class.new(namespace: namespace).execute }

      expect(mailer).to have_received(:limit_warning).once
    end

    it 'sends again in the next billing cycle' do
      record_ai_usage(80)
      isolated_service_class.new(namespace: namespace).execute

      travel 1.month
      record_ai_usage(80)
      isolated_service_class.new(namespace: namespace).execute

      expect(mailer).to have_received(:limit_warning).twice
    end

    it 'still warns after a warning was already sent for the other resource' do
      UsageLimitNotification.claim(
        namespace: nil, usage_kind: :workflow, notification_kind: :warning,
        cycle_start: Sagittarius::BillingCycle.range_for(Date.new(2026, 1, 15)).begin
      )
      record_ai_usage(80)

      expect(service_response).to be_success
      expect(mailer).to have_received(:limit_warning)
    end

    it 'reports the unrestricted resource as unlimited' do
      record_ai_usage(100)

      expect(service_response).to be_success
      expect(UsageLimitMailer).to have_received(:with).with(hash_including(workflow_limit: nil))
    end

    it 'leaves out administrators who should not be mailed' do
      create(:user, admin: true, blocked_at: Time.current)
      record_ai_usage(100)

      expect(service_response).to be_success
      expect(UsageLimitMailer).to have_received(:with).exactly(1).time
    end

    it 'mails every administrator' do
      second_administrator = create(:user, admin: true)
      record_ai_usage(100)

      expect(service_response).to be_success
      expect(UsageLimitMailer).to have_received(:with).with(hash_including(user: administrator))
      expect(UsageLimitMailer).to have_received(:with).with(hash_including(user: second_administrator))
    end
  end

  context 'with a license restricting both resources' do
    before do
      travel_to(Date.new(2026, 9, 20))
      create(:license, start_date: Date.new(2026, 1, 15), end_date: Date.new(2027, 1, 14),
                       restrictions: { ai_tokens: 100, workflow_executions: 10 })
    end

    it 'covers both in a single mail when both ran out' do
      record_ai_usage(100)
      record_workflow_usage(10)

      expect(service_response.payload[:notified]).to eq([:reached])
      expect(mailer).to have_received(:limit_reached).once
      expect(UsageLimitMailer).to have_received(:with).with(
        hash_including(affected_resources: 'AI tokens and workflow executions')
      )
    end

    it 'sends a warning and a limit-reached mail when the two are in different states' do
      record_ai_usage(100)
      record_workflow_usage(8)

      expect(service_response.payload[:notified]).to eq(%i[reached warning])
      expect(UsageLimitMailer).to have_received(:with).with(hash_including(affected_resources: 'AI tokens'))
      expect(UsageLimitMailer).to have_received(:with).with(hash_including(affected_resources: 'workflow executions'))
    end
  end

  context 'when the notification cannot be worked out' do
    before do
      create(:license, restrictions: { ai_tokens: 1 })
      record_ai_usage(1)
      allow(UsageLimitMailer).to receive(:with).and_raise(StandardError, 'nope')
    end

    it 'fails without taking the usage recording down with it' do
      expect(service_response).to be_error
      expect(service_response.payload[:error_code]).to eq(:usage_limit_notification_failed)
    end
  end
end
