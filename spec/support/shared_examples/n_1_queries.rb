# frozen_string_literal: true

RSpec.shared_examples 'prevents N+1 queries' do |**kwargs|
  it 'does not exceed query limit' do
    # warm-up
    action.call

    control_file = nil
    check_file = nil
    if kwargs[:query_recorder_debug] && kwargs[:log_name]
      log_name = kwargs.delete(:log_name)

      FileUtils.mkdir_p(Rails.root.join('tmp/query_recorder'))
      control_file = Rails.root.join('tmp/query_recorder', "#{log_name}_control.txt")
      check_file = Rails.root.join('tmp/query_recorder', "#{log_name}_check.txt")
    end

    control = ActiveRecord::QueryRecorder.new(log_file: control_file, **kwargs, &action)

    create_new_record.call

    check = ActiveRecord::QueryRecorder.new(log_file: check_file, **kwargs, &action)

    expect(check).not_to exceed_query_limit(control)
  end
end

RSpec.shared_examples 'prevents N+1 queries (graphql)', type: :request do |**kwargs|
  include GraphqlHelpers

  include_examples 'prevents N+1 queries', **kwargs do
    let(:current_user) { nil }
    let(:variables) { {} }
    let(:action) do
      -> { post_graphql query, variables: variables, current_user: current_user }
    end
  end
end
