# frozen_string_literal: true

module Velorum
  class GenerateFlowService
    include Code0::ZeroTrack::Loggable

    CACHE_KEY_PREFIX = 'velorum/generate_flow_definitions'

    def initialize(
      current_authentication,
      project:,
      prompt:,
      model_identifier:,
      flow: nil,
      client: nil,
      cache: Rails.cache,
      config: Sagittarius::Configuration.config[:velorum],
      authorize: true
    )
      @current_authentication = current_authentication
      @project = project
      @prompt = prompt
      @model_identifier = model_identifier
      @flow = flow
      @client = client
      @cache = cache
      @config = config
      @authorize = authorize
    end

    def execute
      return missing_permission_response if authorize? && !velorum_config_allowed?
      return disabled_response unless config[:enabled]
      return flow_project_mismatch_response if flow.present? && flow.project != project
      return missing_permission_response if authorize? && !allowed?
      return no_primary_runtime_response if runtime.nil?
      return no_definitions_response unless definitions?

      response = flow.present? ? client.flow(flow_request) : client.prompt(prompt_request)
      logger.debug(
        message: 'Velorum generated flow gRPC response',
        flow: grpc_message_to_h(response.flow)
      )
      write_cache(response.cached_until)

      serialized_flow = GenerationFlowSerializer.new(response.flow, project: project).to_h

      ServiceResponse.success(
        message: 'Generated flow',
        payload: {
          flow: serialized_flow,
          cached_until: response.cached_until,
          usage: response.usage,
        }
      )
    rescue GenerationFlowSerializer::UnresolvedDefinitionError, GRPC::BadStatus => e
      flow_generation_failed_response(e)
    end

    private

    attr_reader :current_authentication, :project, :prompt, :model_identifier, :flow, :cache, :config

    def authorize?
      @authorize
    end

    def prompt_request
      Tucana::Velorum::PromptRequest.new(**base_request_args)
    end

    def flow_request
      Tucana::Velorum::FlowRequest.new(**base_request_args, flow: flow.to_generation_grpc)
    end

    def base_request_args
      args = {
        prompt: prompt,
        project_id: project.id,
        model_identifier: model_identifier,
      }

      return args if definitions_cached?

      args.merge(
        functions: runtime.function_definitions.map(&:to_grpc),
        data_types: runtime.data_types.map(&:to_grpc),
        flow_types: runtime.flow_types.map(&:to_grpc)
      )
    end

    def definitions_cached?
      cached_until = cache.read(cache_key).to_i
      cached_until > current_time_ms
    end

    def write_cache(cached_until)
      return if cached_until.to_i <= current_time_ms

      cache.write(cache_key, cached_until, expires_in: ((cached_until - current_time_ms) / 1000.0).ceil.seconds)
    end

    def cache_key
      [
        CACHE_KEY_PREFIX,
        "project:#{project.id}",
        "runtime:#{runtime.id}",
        "model:#{model_identifier}"
      ].join(':')
    end

    def current_time_ms
      (Time.now.to_f * 1000).to_i
    end

    def grpc_message_to_h(message)
      return if message.nil?
      return message.to_h if message.respond_to?(:to_h)

      message.inspect
    end

    def runtime
      project.primary_runtime
    end

    def definitions?
      runtime.function_definitions.any? && runtime.flow_types.any?
    end

    def client
      @client ||= Sagittarius::Velorum::Client.new
    end

    def velorum_config_allowed?
      Ability.allowed?(current_authentication, :read_velorum_config, :global)
    end

    def allowed?
      ability = flow.present? ? :update_flow : :create_flow
      subject = flow || project

      Ability.allowed?(current_authentication, ability, subject)
    end

    def disabled_response
      ServiceResponse.error(message: 'Velorum is disabled', error_code: :invalid_setting)
    end

    def flow_project_mismatch_response
      ServiceResponse.error(message: 'Flow does not belong to the project', error_code: :invalid_flow)
    end

    def missing_permission_response
      ServiceResponse.error(message: 'Missing permission', error_code: :missing_permission)
    end

    def no_primary_runtime_response
      ServiceResponse.error(message: 'Project has no primary runtime', error_code: :no_primary_runtime)
    end

    def no_definitions_response
      ServiceResponse.error(
        message: 'The primary runtime must provide functions and flow types',
        error_code: :no_definitions
      )
    end

    def flow_generation_failed_response(error)
      ServiceResponse.error(
        message: 'Flow generation failed',
        error_code: :flow_generation_failed,
        details: flow_generation_error_details(error)
      )
    end

    def flow_generation_error_details(error)
      return error.details if error.is_a?(GenerationFlowSerializer::UnresolvedDefinitionError)

      {
        grpc_code: error.respond_to?(:code) ? error.code : nil,
        grpc_details: error.respond_to?(:details) ? error.details : error.message,
      }
    end
  end
end
