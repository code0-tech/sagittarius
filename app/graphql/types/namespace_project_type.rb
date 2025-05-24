# frozen_string_literal: true

module Types
  class NamespaceProjectType < Types::BaseObject
    description 'Represents a namespace project'

    authorize :read_namespace_project

    field :description, String, null: false, description: 'Description of the project'
    field :name, String, null: false, description: 'Name of the project'

    field :namespace, Types::NamespaceType, null: false,
                                            description: 'The namespace where this project belongs to'
    field :primary_runtime, Types::RuntimeType, null: true, description: 'The primary runtime for the project'

    id_field NamespaceProject
    timestamps
  end
end
