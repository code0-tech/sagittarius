# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    description 'Root Query type'

    field :node, Types::NodeType, null: true, description: 'Fetches an object given its ID' do
      argument :id, ID, required: true, description: 'ID of the object'
    end

    field :nodes, [Types::NodeType, { null: true }], null: true,
                                                     description: 'Fetches a list of objects given a list of IDs' do
      argument :ids, [ID], required: true, description: 'IDs of the objects'
    end

    # rubocop:disable GraphQL/ExtractType -- these are intentionally at the root
    field :current_authorization, Types::AuthorizationType, null: true,
                                                            description: 'Get the currently logged in authorization'
    field :current_user, Types::UserType, null: true, description: 'Get the currently logged in user'
    # rubocop:enable GraphQL/ExtractType

    field :application_settings, Types::ApplicationSettingsType, null: true,
                                                                 description: 'Get global application settings'

    field :echo, GraphQL::Types::String, null: false, description: 'Field available for use to test API access' do
      argument :message, GraphQL::Types::String, required: true, description: 'String to echo as response'
    end

    field :team, Types::TeamType, null: true, description: 'Find a team' do
      argument :id, Types::GlobalIdType[::Team], required: false, description: 'GlobalID of the target team'
      argument :name, GraphQL::Types::String, required: false, description: 'Name of the target team'

      require_one_of %i[id name]
    end

    def node(id:)
      context.schema.object_from_id(id, context)
    end

    def nodes(ids:)
      ids.map { |id| context.schema.object_from_id(id, context) }
    end

    def application_settings
      ApplicationSetting.current
    end

    def echo(message:)
      message
    end

    def team(**args)
      args[:id] = args[:id].model_id if args[:id].present?

      TeamsFinder.new(**args, single: true).execute
    end
  end
end
