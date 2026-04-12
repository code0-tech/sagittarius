# frozen_string_literal: true

module Namespaces
  module Projects
    class ReassignFlowDefinitionsToRuntimeService
      include Sagittarius::Database::Transactional

      attr_reader :project, :runtime

      def initialize(project, runtime)
        @project = project
        @runtime = runtime
      end

      def execute
        transactional do
          project.flows.find_each do |flow|
            Flows::ReassignDefinitionsToRuntimeService.new(flow, runtime).execute
          end
        end
      end
    end
  end
end
