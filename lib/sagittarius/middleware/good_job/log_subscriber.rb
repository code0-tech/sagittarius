# frozen_string_literal: true

module Sagittarius
  module Middleware
    module GoodJob
      module LogSubscriber
        extend ActiveSupport::Concern

        include Sagittarius::Loggable

        def finished_timer_task(event)
          exception = event.payload[:error]
          return unless exception

          in_context { logger.error(exception: exception) }
        end

        def finished_job_task(event)
          exception = event.payload[:error]
          return unless exception

          in_context { logger.error(exception: exception) }
        end

        def scheduler_create_pool(event)
          max_threads = event.payload[:max_threads]
          performer_name = event.payload[:performer_name]
          process_id = event.payload[:process_id]

          in_context do
            logger.info(
              message: 'Scheduler started',
              version: ::GoodJob::VERSION,
              queues: performer_name,
              max_threads: max_threads,
              process_id: process_id
            )
          end
        end

        def cron_manager_start(event)
          cron_entries = event.payload[:cron_entries]

          in_context do
            logger.info(
              message: 'Cron started',
              cron_entries: cron_entries
            )
          end
        end

        def scheduler_shutdown_start(event)
          in_context { logger.info(message: 'Scheduler shutting down', process_id: event.payload[:process_id]) }
        end

        def scheduler_shutdown(event)
          in_context { logger.info(message: 'Scheduler is shut down', process_id: event.payload[:process_id]) }
        end

        def scheduler_shutdown_kill(event)
          active_job_ids = event.payload.fetch(:active_job_ids, [])

          in_context do
            if active_job_ids.any?
              logger.warn(message: 'Scheduler has been killed', interrupted_job_ids: active_job_ids)
            else
              logger.warn(message: 'Scheduler has been killed')
            end
          end
        end

        def scheduler_restart_pools(event)
          in_context { logger.info(message: 'Scheduler has restarted', process_id: event.payload[:process_id]) }
        end

        def perform_job(event)
          job = event.payload[:job]
          process_id = event.payload[:process_id]
          thread_name = event.payload[:thread_name]

          in_context do
            logger.info(
              message: 'Executed job',
              execution_id: job.id,
              process_id: process_id,
              thread_name: thread_name
            )
          end
        end

        def notifier_listen(*)
          in_context { logger.info('Notifier subscribed with LISTEN') }
        end

        def notifier_notified(event)
          payload = event.payload[:payload]

          in_context { logger.debug(message: 'Notifier received payload', payload: payload) }
        end

        def notifier_notify_error(event)
          exception = event.payload[:error]

          in_context { logger.error(message: 'Notifier errored', exception: exception) }
        end

        def notifier_unlisten(*)
          in_context { logger.info('NOTIFIER unsubscribed with UNLISTEN') }
        end

        def cleanup_preserved_jobs(event)
          in_context do
            logger.info(
              message: 'Destroyed preserved job execution records',
              record_count: event.payload[:destroyed_records_count],
              before_timestamp: event.payload[:timestamp]
            )
          end
        end

        def systemd_watchdog_start(event)
          in_context { logger.info(message: 'Pinging systemd watchdog', interval_s: event.payload[:interval]) }
        end

        def systemd_watchdog_error(event)
          in_context { logger.error(message: 'Error pinging systemd', exception: event.payload[:error]) }
        end

        def in_context(&block)
          Sagittarius::Context.with_context(application: 'good_job', &block)
        end
      end
    end
  end
end
