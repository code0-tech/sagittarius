# frozen_string_literal: true

Runtime.seed_once :name do |runtime|
  runtime.name = 'Development Runtime'
  runtime.token = 'development_runtime_token'
end
