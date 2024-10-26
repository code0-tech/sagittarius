# frozen_string_literal: true

module InjectExtensions
  def prepend_extensions(constant: name, namespace: Object)
    extensions = active_extensions(constant, namespace).each do |extension|
      prepend extension
    end
    return if extensions.empty?

    InjectExtensions.extended_constants[self] = extensions if Rails.env.test?
  end

  def self.extended_constants
    @extended_constants ||= {}
  end

  def active_extensions(constant, namespace)
    Sagittarius::Extensions.active.map do |extension|
      extension_namespace = find_const(namespace, extension.upcase)
      extension_module = find_const(extension_namespace, constant) if extension_namespace

      extension_module if extension_module
    end.compact
  end

  def find_const(mod, name)
    mod&.const_defined?(name, false) && mod.const_get(name, false)
  end
end

Module.prepend(InjectExtensions)
