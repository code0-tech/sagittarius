# frozen_string_literal: true

module CLOUD
  module Namespace
    extend ActiveSupport::Concern

    prepended do
      has_many :licenses, inverse_of: :namespace
    end

    def current_license
      ::License.current_for_namespace(self)
    end
  end
end
