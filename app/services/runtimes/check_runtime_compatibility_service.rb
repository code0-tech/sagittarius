# frozen_string_literal: true

module Runtimes
  class CheckRuntimeCompatibilityService
    attr_reader :runtime, :namespace_project

    def initialize(runtime, namespace_project)
      @runtime = runtime
      @namespace_project = namespace_project
    end

    def execute
      primary_runtime = namespace_project.primary_runtime

      if primary_runtime.nil?
        return ServiceResponse.error(message: 'No primary runtime given',
                                     payload: :missing_primary_runtime)
      end

      { DataType => :identifier, FlowType => :identifier,
        RuntimeFunctionDefinition => :runtime_name }.each do |model, identifier_field|
        res = check_versions(model, identifier_field)
        return res if res.error?
      end
      ServiceResponse.success(message: 'Runtime is compatible', payload: runtime)
    end

    def check_versions(model, identifier_field = :identifier)
      to_check_types = model.where(runtime: runtime)
      primary_types = model.where(runtime: namespace_project.primary_runtime)

      if to_check_types.size < primary_types.size
        return ServiceResponse.error(message: "#{model} amount dont match",
                                     payload: :missing_definition)
      end

      primary_types.each do |curr_type|
        to_check = model.find_by(runtime: runtime, identifier_field => curr_type.send(identifier_field))
        if to_check.nil?
          return ServiceResponse.error(message: "#{model} is not present in new runtime",
                                       payload: :missing_definition)
        end

        result = compare_version(curr_type.parsed_version, to_check.parsed_version)

        unless result
          return ServiceResponse.error(message: "#{model} is outdated",
                                       payload: :outdated_definition)
        end
      end
      ServiceResponse.success
    end

    def compare_version(primary_version, to_check_version)
      return false if primary_version.segments[0] != to_check_version.segments[0]
      return false if primary_version.segments[1] < to_check_version.segments[1]

      true
    end
  end
end
