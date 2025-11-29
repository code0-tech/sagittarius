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

    field :application, Types::ApplicationType, null: false,
                                                description: 'Get application information'

    field :echo, GraphQL::Types::String, null: false, description: 'Field available for use to test API access' do
      argument :message, GraphQL::Types::String, required: true, description: 'String to echo as response'
    end

    field :organization, Types::OrganizationType, null: true, description: 'Find a organization' do
      argument :id, Types::GlobalIdType[::Organization], required: false,
                                                         description: 'GlobalID of the target organization'
      argument :name, GraphQL::Types::String, required: false, description: 'Name of the target organization'

      require_one_of %i[id name]
    end

    field :organizations, Types::OrganizationType.connection_type, null: false, description: 'Find organizations'

    field :namespace, Types::NamespaceType, null: true, description: 'Find a namespace' do
      argument :id, Types::GlobalIdType[::Namespace], required: true, description: 'GlobalID of the target namespace'
    end

    field :user, Types::UserType, null: true, description: 'Find a user' do
      argument :id, Types::GlobalIdType[::User], required: false, description: 'GlobalID of the target user'

      argument :username, GraphQL::Types::String, required: false, description: 'Username of the target user'

      require_one_of %i[id username]
    end

    field :users, Types::UserType.connection_type, null: false, description: 'Find users'

    field :global_runtimes, Types::RuntimeType.connection_type, null: false, description: 'Find runtimes'

    expose_abilities %i[
      create_organization
      create_runtime
      delete_runtime
      update_runtime
      rotate_runtime_token
      update_application_setting
    ], entity_name: 'Instance', subject_resolver: -> { :global }

    def node(id:)
      context.schema.object_from_id(id, context)
    end

    def nodes(ids:)
      ids.map { |id| context.schema.object_from_id(id, context) }
    end

    def application
      {}
    end

    def echo(message:)
      message
    end

    def organization(**args)
      args[:id] = args[:id].model_id if args[:id].present?

      OrganizationsFinder.new(**args, single: true).execute
    end

    def organizations
      return Organization.all if current_user&.admin?

      OrganizationsFinder.new(namespace_member_user: current_user).execute
    end

    def namespace(id:)
      SagittariusSchema.object_from_id(id)
    end

    def user(id: nil, username: nil)
      if id.present?
        SagittariusSchema.object_from_id(id)
      elsif username.present?
        User.find_by(username: username)
      end
    end

    def users
      return User.none unless Ability.allowed?(context[:current_authentication], :list_users, :global)

      User.all
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
