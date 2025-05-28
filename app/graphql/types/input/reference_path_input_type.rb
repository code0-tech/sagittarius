# frozen_string_literal: true

module Types
  module Input
    class ReferencePathInputType < Types::BaseInputObject
      description 'Input type for reference path'

      argument :array_index, Integer, required: false,
                                      description: 'Array index if applicable'
      argument :path, String, required: false,
                              description: 'The path to the reference in the flow'
    end
  end
end
