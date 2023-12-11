# frozen_string_literal: true

module Sagittarius
  module Middleware
    module Sidekiq
      module Context
        class Client
          include ::Sidekiq::ClientMiddleware

          def call(_job_class, job, _queue, _redis_pool)
            Sagittarius::Context.with_context do |context|
              job.merge!(context.to_h)

              yield
            end
          end
        end
      end
    end
  end
end
