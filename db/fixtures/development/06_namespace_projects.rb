# frozen_string_literal: true

NamespaceProject.seed_once :namespace_id, :name do |np|
  np.namespace_id = Organization.find_by(name: 'Code1').ensure_namespace.id
  np.name = 'First Project'
  np.description = 'A sample project for Code1 organization.'
  np.primary_runtime = Runtime.find_by(name: 'Code1-Runtime')
  np.runtimes = [Runtime.find_by(name: 'Code1-Runtime')]
end
