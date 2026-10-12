# frozen_string_literal: true

module CLOUD
  module Namespace
    extend ActiveSupport::Concern
    include Code0::ZeroTrack::Memoize

    prepended do
      has_many :licenses, inverse_of: :namespace
    end

    def current_license
      memoize(:current_license) do
        ::License.current_for_namespace(self)
      end
    end
  end
end
