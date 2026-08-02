# frozen_string_literal: true

module NamespaceParent
  extend ActiveSupport::Concern

  included do
    has_one :namespace, as: :parent
  end

  def ensure_namespace
    return namespace if namespace.present?
    return build_namespace unless persisted?

    ns = Namespace.create_or_find_by(parent: self)
    association(:namespace).target = ns
    ns.ensure_personal_namespace_administrator! if ns.user_type?
    ns
  end
end
