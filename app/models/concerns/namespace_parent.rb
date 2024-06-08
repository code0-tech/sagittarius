module NamespaceParent
  extend ActiveSupport::Concern

  included do
    has_one :namespace, as: :parent
  end

  def ensure_namespace
    return namespace if namespace.present?

    ns = build_namespace
    ns.save if persisted?
    ns
  end
end
