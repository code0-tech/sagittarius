# frozen_string_literal: true

namespace :orchestrator do
  def auto_reenable_task(*args, **kwargs, &block)
    task(*args, **kwargs, &block).enhance { |t, _| t.reenable }
  end

  task build_state: :environment do
    Rails.application.eager_load!
    Sagittarius::Orchestrator::State.build!
  end

  auto_reenable_task :start, [:container] => :build_state do |_, args|
    container = Sagittarius::Orchestrator::State[args[:container]]
    Sagittarius::Orchestrator::Operator.ensure_container_up!(container)
  end

  auto_reenable_task :find, [:container] => :build_state do |_, args|
    p Sagittarius::Orchestrator::State[args[:container]]
  end

  auto_reenable_task :stop, [:container] => :build_state do |_, args|
    container = Sagittarius::Orchestrator::State[args[:container]]
    Sagittarius::Orchestrator::Operator.ensure_container_down!(container)
  end

  auto_reenable_task :force_recreate, [:container] => :build_state do |_, args|
    container = Sagittarius::Orchestrator::State[args[:container]]

    operator = Sagittarius::Orchestrator::Operator
    operator.ensure_container_down!(container)
    operator.ensure_container_up!(container)
  end

  task state: :build_state do
    p Sagittarius::Orchestrator::State.containers
    p Sagittarius::Orchestrator::State.volumes
  end

  task connect_self: :build_state do
    Sagittarius::Orchestrator::Operator.ensure_self_connected!
  end

  auto_reenable_task :assert_healthy, [:container] => :build_state do |_, args|
    abort("#{args[:container]} is not healthy") unless Sagittarius::Orchestrator::State[args[:container]].healthy?
  end

  auto_reenable_task :await_healthy, %i[container timeout min_attempts] => :build_state do |_, args|
    timeout = args.fetch(:timeout, 30).to_i
    min_attempts = args.fetch(:min_attempts, 2).to_i
    container = Sagittarius::Orchestrator::State[args[:container]]

    total_attempts = 0
    successful_attempts = 0
    (0..timeout).each do
      total_attempts += 1
      if container.healthy?
        successful_attempts += 1
      else
        successful_attempts = 0
      end

      break if successful_attempts >= min_attempts

      sleep 1
    end

    if successful_attempts >= min_attempts
      puts "#{container.name} is healthy after #{total_attempts} seconds"
    elsif container.healthy?
      abort("#{container.name} did get healthy, but did not meet health threshold of " \
            "#{min_attempts} within #{timeout} seconds")
    else
      abort("#{container.name} did not get healthy within #{timeout} seconds")
    end
  end

  task :create_connection_environment, [] => :build_state do |_, args|
    env_variables = args.extras.each_with_object({}) do |container_name, obj|
      container = Sagittarius::Orchestrator::State[container_name]
      next unless container.respond_to?(:orchestrator_connection_details)

      obj.merge!(container.orchestrator_connection_details)
    end

    puts env_variables.map { |key, value| "export #{key}=#{value}" }.join("\n")
  end

  if Rails.env.local?
    namespace :dev do
      task start: :build_state do
        Rake::Task['orchestrator:start'].invoke('postgresql')
        Rake::Task['orchestrator:start'].invoke('redis')
      end

      task stop: :build_state do
        Rake::Task['orchestrator:stop'].invoke('postgresql')
        Rake::Task['orchestrator:stop'].invoke('redis')
      end

      task force_recreate: :build_state do
        Rake::Task['orchestrator:force_recreate'].invoke('postgresql')
        Rake::Task['orchestrator:force_recreate'].invoke('redis')
      end
    end
  end
end
