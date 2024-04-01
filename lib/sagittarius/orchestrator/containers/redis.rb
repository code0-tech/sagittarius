# frozen_string_literal: true

module Sagittarius
  module Orchestrator
    module Containers
      class Redis < Container
        def image
          'redis:7.2.3-alpine'
        end

        def name
          'redis'
        end

        def cmd
          %w[redis-server --save 1 1 --loglevel warning]
        end

        def volumes
          {
            data: '/data',
          }
        end

        def ports
          {
            '6379/tcp' => [{ 'HostIp' => '127.0.0.1', 'HostPort' => '6380' }],
          }
        end

        def last_ip_number
          5
        end

        def orchestrator_connection_details
          return {} unless healthy?

          {
            SAGITTARIUS_REDIS_HOST: internal_container.info['Name'].delete_prefix('/'),
            SAGITTARIUS_REDIS_PORT: 6379,
          }
        end
      end
    end
  end
end
