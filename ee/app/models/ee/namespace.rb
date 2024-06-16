# frozen_string_literal: true

module EE
  module Namespace
    extend ActiveSupport::Concern

    prepended do
      has_many :namespace_licenses, inverse_of: :namespace
    end

    def current_license
      NamespaceLicense.current(self)
    end
  end
end
