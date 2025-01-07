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
    field :current_authentication, Types::AuthenticationType, null: true,
                                                              description: 'Get the currently logged in authentication'
    field :current_user, Types::UserType, null: true, description: 'Get the currently logged in user'
    # rubocop:enable GraphQL/ExtractType

    field :application_settings, Types::ApplicationSettingsType, null: true,
                                                                 description: 'Get global application settings'

    field :echo, GraphQL::Types::String, null: false, description: 'Field available for use to test API access' do
      argument :message, GraphQL::Types::String, required: true, description: 'String to echo as response'
    end

    field :organization, Types::OrganizationType, null: true, description: 'Find a organization' do
      argument :id, Types::GlobalIdType[::Organization], required: false,
                                                         description: 'GlobalID of the target organization'
      argument :name, GraphQL::Types::String, required: false, description: 'Name of the target organization'

      require_one_of %i[id name]
    end

    field :namespace, Types::NamespaceType, null: true, description: 'Find a namespace' do
      argument :id, Types::GlobalIdType[::Namespace], required: true, description: 'GlobalID of the target namespace'
    end

    field :global_runtimes, Types::RuntimeType.connection_type, null: false, description: 'Find runtimes'

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

    def organization(**args)
      args[:id] = args[:id].model_id if args[:id].present?

      OrganizationsFinder.new(**args, single: true).execute
    end

    def namespace(id:)
      SagittariusSchema.object_from_id(id)
    end

    def global_runtimes
      Runtime.where(namespace: nil)
    end

    def current_authentication
      super.authentication
    end

    def current_user
      current_authentication&.user
    end
  end
end
