# frozen_string_literal: true

module Sagittarius
  module Orchestrator
    class Container
      attr_accessor :internal_container

      def image
        raise NotImplementedError
      end

      def name
        raise NotImplementedError
      end

      def cmd
        nil
      end

      def environment_variables
        []
      end

      def volumes
        []
      end

      def ports
        nil
      end

      def healthy?
        return false if internal_container.nil?

        internal_container.refresh!
        internal_container.info['State']['Status'] == 'running'
      end

      def self.[](container)
        Containers.const_get(container.capitalize).new
      end
    end
  end
end
