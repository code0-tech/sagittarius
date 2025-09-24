# frozen_string_literal: true

module Types
  class NamespaceProjectType < Types::BaseObject
    description 'Represents a namespace project'

    authorize :read_namespace_project

    field :description, String, null: false, description: 'Description of the project'

    field :name, String, null: false, description: 'Name of the project'

    field :runtimes, Types::RuntimeType.connection_type, null: false, description: 'Runtimes assigned to this project'

    field :namespace, Types::NamespaceType, null: false,
                                            description: 'The namespace where this project belongs to'

    field :primary_runtime, Types::RuntimeType, null: true, description: 'The primary runtime for the project'

    field :flow, Types::FlowType, null: true, description: 'Fetches an flow given by its ID' do
      argument :id, Types::GlobalIdType[::Flow], required: true, description: 'Id of the flow'
    end

    field :flows, Types::FlowType.connection_type, null: true, description: 'Fetches all flows in this project'

    id_field NamespaceProject
    timestamps

    def flow(id:)
      object.flows.find(id: id)
    end
  end
end
