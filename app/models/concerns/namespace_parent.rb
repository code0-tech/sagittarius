# frozen_string_literal: true

module NamespaceParent
  extend ActiveSupport::Concern

  included do
    has_one :namespace, as: :parent
  end

  def ensure_namespace
    return namespace if namespace.present?

    ns = build_namespace
    if persisted?
      ns.save
      ns.ensure_personal_namespace_administrator! if ns.user_type?
    end
    ns
  end
end
