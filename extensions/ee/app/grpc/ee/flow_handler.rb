# frozen_string_literal: true

module EE
  module FlowHandler
    include Sagittarius::Override
    extend ActiveSupport::Concern

    override :flows_for
    def flows_for(runtime)
      return Tucana::Shared::Flows.new(flows: []) if License.current.nil?

      super
    end

    class_methods do
      include Sagittarius::Override

      override :push_to_project_runtimes
      def push_to_project_runtimes(project, response)
        return if License.current.nil?

        super
      end

      override :update_runtime
      def update_runtime(runtime)
        return push_empty_flows(runtime) if License.current.nil?

        super
      end

      private

      def push_empty_flows(runtime)
        gateway_client.push_flow(
          runtime.id,
          Tucana::Sagittarius::Gateway::FlowResponse.new(flows: Tucana::Shared::Flows.new(flows: []))
        )
      end
    end
  end
end
