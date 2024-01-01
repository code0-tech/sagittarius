# frozen_string_literal: true

RSpec.shared_examples 'prevents N+1 queries' do
  it 'does not exceed query limit' do
    # warm-up
    action.call

    control = ActiveRecord::QueryRecorder.new(&action)

    create_new_record.call

    expect { action.call }.not_to exceed_query_limit(control)
  end
end

RSpec.shared_examples 'prevents N+1 queries (graphql)', type: :request do
  include GraphqlHelpers

  include_examples 'prevents N+1 queries' do
    let(:current_user) { nil }
    let(:variables) { {} }
    let(:action) do
      -> { post_graphql query, variables: variables, current_user: current_user }
    end
  end
end
