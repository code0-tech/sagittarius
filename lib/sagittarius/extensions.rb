# frozen_string_literal: true

module Sagittarius
  module Extensions
    module_function

    AVAILABLE_EXTENSIONS = %i[ee].freeze

    def active
      extensions = []

      AVAILABLE_EXTENSIONS.each do |extension|
        extensions << extension if send(:"#{extension}?")
      end

      extensions
    end

    AVAILABLE_EXTENSIONS.each do |extension|
      define_method(:"#{extension}?") do
        root.join(extension.to_s).exist? && !Utils.to_boolean(
          ENV.fetch("SAGITTARIUS_DISABLE_#{extension.upcase}", 'false'), default: false
        )
      end

      define_method(extension) do |&block|
        block.call if send(:"#{extension}?")
      end
    end

    def root
      Pathname.new(File.expand_path('../../', __dir__))
    end
  end
end
