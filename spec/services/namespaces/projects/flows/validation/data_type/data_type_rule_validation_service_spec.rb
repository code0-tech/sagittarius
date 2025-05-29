require 'rails_helper'

RSpec.describe Namespaces::Projects::Flows::Validation::DataType::DataTypeRuleValidationService do

  subject(:service_response) { described_class.new(create_authentication(current_user), flow, data_type, rule).execute }

  let(:current_user) { create(:user) }
  let(:runtime) { create(:runtime) }
  let(:namespace_project) { create(:namespace_project).tap { |np| np.primary_runtime = runtime } }
  let(:flow) { create(:flow, project: namespace_project) }
  let(:data_type) { create(:data_type) }
  let(:rule) { create(:data_type_rule, data_type: data_type, variant: :regex, config: { pattern: '.*' }) }

  context 'when rule is valid' do
    it { expect(service_response).to eq(nil) }
  end

  context 'when rule is invalid' do
    let(:rule) { build(:data_type_rule, data_type: data_type, variant: :regex, config: { not_a_valid_key: '.*' }) }

    it 'returns an error message' do
      expect(service_response).to be_error
      expect(rule.errors.full_messages).to include("Config is not a valid JSON schema")
    end
  end
end
