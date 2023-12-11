# frozen_string_literal: true

module Sagittarius
  module Middleware
    module Sidekiq
      module Context
        class Server
          include ::Sidekiq::ServerMiddleware

          def call(_job_instance, job_payload, _queue, &block)
            job_name = (job_payload['wrapped'].presence || job_payload['class']).to_s
            data = job_payload.merge(Sagittarius::Context.log_key(:caller_id) => job_name,
                                     Sagittarius::Context.log_key(:jid) => job_payload['jid'],
                                     Sagittarius::Context.log_key(:application) => 'sidekiq')
                              .select do |key, _|
              key.start_with?("#{Sagittarius::Context::LOG_KEY}.") || Sagittarius::Context::RAW_KEYS.include?(key.to_s)
            end

            Sagittarius::Context.with_context(data, &block)
          end
        end
      end
    end
  end
end
