# frozen_string_literal: true

module Mutations
  module Licenses
    class Create < BaseMutation
      description '(EE only) Create a new license.'

      field :license, Types::LicenseType, null: true, description: 'The newly created license.'

      argument :data, String, required: true, description: 'The license data.'

      def resolve(data:)
        ::Licenses::CreateService.new(
          current_authentication,
          data: data
        ).execute.to_mutation_response(success_key: :license)
      end
    end
  end
end
