# frozen_string_literal: true

module Sagittarius
  module Orchestrator
    module Containers
      class Postgresql < Container
        def image
          'postgres:16.1'
        end

        def name
          'postgresql'
        end

        def environment_variables
          config = ActiveRecord::Base.connection_db_config.configuration_hash

          %W[
            POSTGRES_USER=#{config[:username]}
            POSTGRES_PASSWORD=#{config[:password]}
            POSTGRES_DB=#{config[:database]}
          ]
        end

        def volumes
          {
            data: '/var/lib/postgresql/data/',
          }
        end

        def ports
          {
            '5432/tcp' => [{ 'HostIp' => '127.0.0.1', 'HostPort' => '5433' }],
          }
        end

        def healthy?
          # exec returns [[stdout], [], exit_code]
          super && internal_container.exec(%w[pg_isready]).last.zero?
        end

        def last_ip_number
          4
        end

        def orchestrator_connection_details
          return {} unless healthy?

          {
            SAGITTARIUS_DATABASE_HOST: internal_container.info['Name'].delete_prefix('/'),
            SAGITTARIUS_DATABASE_PORT: 5432,
          }
        end
      end
    end
  end
end
