# frozen_string_literal: true

Runtime.seed_once :name do |runtime|
  runtime.name = 'Global Runtime'
  runtime.description = 'A global runtime available to all projects.'
  runtime.token = 'global'
end

Runtime.seed_once :name do |runtime|
  runtime.name = 'Code1-Runtime'
  runtime.description = 'A runtime specific to an organization.'
  runtime.namespace = Organization.find_by(name: 'Code1').ensure_namespace
  runtime.token = 'code1-runtime'
end
