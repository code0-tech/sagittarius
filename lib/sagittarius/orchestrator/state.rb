# frozen_string_literal: true

module Sagittarius
  module Orchestrator
    class State
      class << self
        attr_accessor :containers, :volumes

        def build!
          build_containers!
          build_volumes!
        end

        def build_containers!
          docker_containers = Docker::Container.all(
            all: true,
            filters: JSON.dump({ 'label' => [Operator::CONTAINER_NAME_LABEL] })
          ).to_h do |c|
            label = c.info['Labels'][Operator::CONTAINER_NAME_LABEL]
            next [nil, nil] if label.nil?

            [label, c]
          end

          @containers = Container.descendants.to_h do |clazz|
            container = clazz.new
            container.internal_container = docker_containers[container.name]
            [container.name, container]
          end
        end

        def build_volumes!
          @volumes = Docker::Volume.all(
            filters: JSON.dump({ 'label' => [Operator::VOLUME_NAME_LABEL] })
          ).each_with_object({}) do |v, obj|
            name_label = v.info.dig('Labels', Operator::VOLUME_NAME_LABEL)
            container_label = v.info.dig('Labels', Operator::VOLUME_CONTAINER_LABEL)
            next if name_label.nil? || container_label.nil?

            obj[container_label] ||= {}
            obj[container_label][name_label] = v
          end
        end

        def [](container_name)
          @containers[container_name]
        end

        def self_container_id
          container_id_from_cgroup || container_id_from_daemon_search
        end

        private

        def container_id_from_cgroup
          File.readlines('/proc/self/cgroup').find { |line| line.include?('docker') }&.split('/')&.last&.chomp
        rescue Errno::ENOENT
          nil
        end

        def container_id_from_daemon_search
          Docker::Container.all
                           .filter { |c| c.info['Image'].include?('sagittarius') }
                           .reject { |c| c.info['Labels'].key?(Operator::CONTAINER_NAME_LABEL) }
                           .find { |c| c.info['Command'] == '/rails/bin/docker-entrypoint ./bin/rails server' }
                           &.id
        end
      end
    end
  end
end
