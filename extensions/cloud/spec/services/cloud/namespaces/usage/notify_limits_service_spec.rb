# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Namespaces::Usage::NotifyLimitsService do
  subject(:service_response) { described_class.new(namespace: namespace).execute }

  let(:namespace) { project.namespace }
  let(:project) { create(:namespace_project) }
  let(:other_project) { create(:namespace_project) }

  # Cloud notifies the namespace's own administrators: a member holding a role with the
  # namespace_administrator ability.
  let(:namespace_administrator) { create(:user) }

  before do
    member = create(:namespace_member, namespace: namespace, user: namespace_administrator)
    role = create(:namespace_role, namespace: namespace)
    create(:namespace_role_ability, namespace_role: role, ability: :namespace_administrator)
    create(:namespace_member_role, role: role, member: member)
  end

  def record_ai_usage(for_project, tokens)
    AiUsageDailyAggregate.record_generation!(
      project_id: for_project.id, namespace_id: for_project.namespace_id,
      flow_id: AiUsageDailyAggregate::NO_FLOW, usage: tokens, unique_by: %i[project_id flow_id date]
    )
  end

  it { expect(described_class).to include_module(CLOUD::Namespaces::Usage::NotifyLimitsService) }

  context 'without a license' do
    let(:free_ai_limit) { CLOUD::Namespaces::Projects::EnforceAiUsageLimitService::FREE_AI_TOKEN_LIMIT }

    context 'with the free tier used up' do
      before { record_ai_usage(project, free_ai_limit) }

      it 'measures against the free-tier limit that is actually enforced' do
        expect(service_response.payload[:notified]).to eq([:reached])
      end

      it_behaves_like 'sends an email' do
        let(:mailer_class) { UsageLimitMailer }
        let(:mail_method) { :limit_reached }
        let(:mail_params) do
          hash_including(user: namespace_administrator, ai_limit: free_ai_limit, affected_resources: 'AI tokens')
        end
      end
    end

    context 'with the free tier barely touched' do
      before { record_ai_usage(project, 1) }

      it 'stays quiet' do
        expect(service_response.payload[:notified]).to be_empty
      end

      it_behaves_like 'sends no email' do
        let(:mailer_class) { UsageLimitMailer }
        let(:mail_method) { :limit_reached }
        let(:mail_params) { hash_including(user: namespace_administrator) }
      end
    end
  end

  context 'with a license for the namespace' do
    before do
      create(:license, namespace: namespace, start_date: Date.current - 1.day, end_date: Date.current + 1.year,
                       restrictions: { ai_tokens: 100 })
    end

    context 'with the licensed limit reached' do
      before { record_ai_usage(project, 100) }

      it 'reports it as reached' do
        expect(service_response.payload[:notified]).to eq([:reached])
      end

      it_behaves_like 'sends an email' do
        let(:mailer_class) { UsageLimitMailer }
        let(:mail_method) { :limit_reached }
        let(:mail_params) { hash_including(ai_limit: 100) }
      end

      it 'leaves the installation administrators out of it' do
        create(:user, admin: true)
        mail_message = instance_double(ActionMailer::MessageDelivery, deliver_later: nil)
        mailer = instance_double(UsageLimitMailer, limit_reached: mail_message)
        allow(UsageLimitMailer).to receive(:with).and_return(mailer)

        expect(service_response).to be_success
        expect(UsageLimitMailer).to have_received(:with).exactly(1).time
      end
    end

    context 'with the usage recorded for another namespace' do
      before { record_ai_usage(other_project, 1_000) }

      it 'ignores it' do
        expect(service_response.payload[:notified]).to be_empty
      end

      it_behaves_like 'sends no email' do
        let(:mailer_class) { UsageLimitMailer }
        let(:mail_method) { :limit_reached }
        let(:mail_params) { hash_including(user: namespace_administrator) }
      end
    end

    context 'with another namespace already notified for this cycle' do
      before do
        UsageLimitNotification.claim(
          namespace: other_project.namespace, usage_kind: :ai, notification_kind: :reached,
          cycle_start: Sagittarius::BillingCycle.range_for(Date.current - 1.day).begin
        )
        record_ai_usage(project, 100)
      end

      it_behaves_like 'sends an email' do
        let(:mailer_class) { UsageLimitMailer }
        let(:mail_method) { :limit_reached }
        let(:mail_params) { hash_including(user: namespace_administrator, ai_limit: 100) }
      end
    end
  end
end
