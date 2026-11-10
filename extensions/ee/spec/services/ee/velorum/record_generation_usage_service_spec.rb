# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Velorum::RecordGenerationUsageService do
  let(:project) { create(:namespace_project) }
  let(:notification) { instance_double(Namespaces::Usage::NotifyLimitsService, execute: nil) }

  before do
    allow(Namespaces::Usage::NotifyLimitsService).to receive(:new).and_return(notification)
  end

  it { expect(described_class).to include_module(EE::Velorum::RecordGenerationUsageService) }

  it 'notifies about the usage limits of the namespace that was billed' do
    expect(described_class.new(project: project, usage: 42).execute).to be_success
    expect(Namespaces::Usage::NotifyLimitsService).to have_received(:new).with(namespace: project.namespace)
    expect(notification).to have_received(:execute)
  end
end
