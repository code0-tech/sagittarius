# frozen_string_literal: true

class SagittariusSchema < GraphQL::Schema
  mutation(Types::MutationType)
  query(Types::QueryType)

  default_max_page_size 50
  max_depth 20
  max_complexity 200
  connections.add(ActiveRecord::Relation, Sagittarius::Graphql::StableConnection)

  # For batch-loading (see https://graphql-ruby.org/dataloader/overview.html)
  use GraphQL::Dataloader

  use GraphQL::Schema::AlwaysVisible

  # rubocop:disable Lint/UselessMethodDefinition
  # GraphQL-Ruby calls this when something goes wrong while running a query:
  def self.type_error(err, context)
    # if err.is_a?(GraphQL::InvalidNullError)
    #   # report to your bug tracker here
    #   return nil
    # end
    super
  end
  # rubocop:enable Lint/UselessMethodDefinition

  # rubocop:disable Lint/UnusedMethodArgument
  # Union and Interface Resolution
  def self.resolve_type(abstract_type, obj, ctx)
    # TODO: Implement this method
    # to return the correct GraphQL object type for `obj`
    raise(GraphQL::RequiredImplementationMissingError)
  end

  # Stop validating when it encounters this many errors:
  validate_max_errors(100)

  # Relay-style Object Identification:

  # Return a string UUID for `object`
  def self.id_from_object(object, type_definition = nil, query_ctx = nil)
    # For example, use Rails' GlobalID library (https://github.com/rails/globalid):
    object.to_gid_param
  end

  # Given a string UUID, find the object
  def self.object_from_id(global_id, query_ctx = nil)
    # For example, use Rails' GlobalID library (https://github.com/rails/globalid):
    GlobalID.find(global_id)
  rescue ActiveRecord::RecordNotFound
    nil
  end

  # rubocop:enable Lint/UnusedMethodArgument
end

if Types::BaseObject.instance_variable_defined?(:@user_ability_types)
  Types::BaseObject.remove_instance_variable(:@user_ability_types) # release temporary type map
end
