# frozen_string_literal: true

module EE
  module FlowHandler
    include Sagittarius::Override
    extend ActiveSupport::Concern

    override :flows_for
    def flows_for(runtime)
      return Tucana::Shared::Flows.new(flows: []) if self.class.no_active_license?

      super
    end

    class_methods do
      include Sagittarius::Override

      # Own method so Cloud can override it away (see CLOUD::FlowHandler).
      def no_active_license?
        License.current.nil?
      end

      override :push_to_project_runtimes
      def push_to_project_runtimes(project, response)
        return if no_active_license?

        super
      end

      override :update_runtime
      def update_runtime(runtime)
        return push_empty_flows(runtime) if no_active_license?

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
