# frozen_string_literal: true

module Sagittarius
  module Orchestrator
    class Operator
      ORCHESTRATOR_LABEL_PREFIX = 'tech.code0.sagittarius.orchestrator'
      CONTAINER_NAME_LABEL = "#{ORCHESTRATOR_LABEL_PREFIX}.container.name".freeze
      NETWORK_NAME_LABEL = "#{ORCHESTRATOR_LABEL_PREFIX}.network.name".freeze
      VOLUME_NAME_LABEL = "#{ORCHESTRATOR_LABEL_PREFIX}.volume.name".freeze
      VOLUME_CONTAINER_LABEL = "#{ORCHESTRATOR_LABEL_PREFIX}.volume.container".freeze

      NoContainerError = Class.new(StandardError)

      class << self
        def ensure_self_connected!
          ensure_network!

          self_container_id = State.self_container_id
          raise NoContainerError, 'self_container_id is nil' if self_container_id.nil?

          network.connect(self_container_id)
        end

        def ensure_container_up!(container)
          ensure_network!
          create_container!(container) if State[container.name].internal_container.nil?

          container.internal_container.refresh!

          unless container.internal_container.info['NetworkSettings']['Networks'].key?(network.info['Name'])
            network.connect(container.internal_container.id)
          end
          container.internal_container.start
        end

        def ensure_container_down!(container)
          destroy_container!(container) unless State[container.name].internal_container.nil?
        end

        def network
          network_id = Docker::Network.all(filters: JSON.dump(
            { 'label' => ["#{NETWORK_NAME_LABEL}=main"] }
          )).first&.id

          return nil if network_id.nil?

          Docker::Network.get(network_id)
        end

        private

        def ensure_network!
          return unless network.nil?

          Docker::Network.create(
            unique_name('code0'),
            'Labels' => { NETWORK_NAME_LABEL => 'main' }
          )
        end

        def ensure_volumes!(container)
          container.volumes.each_key do |name|
            next if State.volumes[container.name]&.key?(name.to_s)

            Docker::Volume.create(
              unique_name("#{container.name}_#{name}"),
              'Labels' => { VOLUME_NAME_LABEL => name, VOLUME_CONTAINER_LABEL => container.name }
            )
          end

          State.build_volumes!
        end

        def create_container!(container)
          ensure_volumes!(container)
          volumes = container.volumes.map do |name, path|
            "#{State.volumes[container.name][name.to_s].info['Name']}:#{path}"
          end

          Docker::Image.create('fromImage' => container.image)
          container.internal_container = Docker::Container.create(
            'name' => unique_name(container.name),
            'Image' => container.image,
            'Labels' => { CONTAINER_NAME_LABEL => container.name },
            'Cmd' => container.cmd,
            'Env' => container.environment_variables,
            'HostConfig' => {
              'Binds' => volumes,
              'PortBindings' => container.ports,
            }
          )
        end

        def destroy_container!(container)
          container.internal_container.stop
          container.internal_container.delete
          container.internal_container = nil
        end

        def unique_name(component)
          "#{component}_#{SecureRandom.hex}"
        end
      end
    end
  end
end
