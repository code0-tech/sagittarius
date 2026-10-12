# frozen_string_literal: true

module CLOUD
  module License
    extend ActiveSupport::Concern

    prepended do
      belongs_to :namespace, inverse_of: :licenses

      scope :for_namespace, ->(namespace) { where(namespace: namespace) }

      class << self
        include Code0::ZeroTrack::Memoize

        def current_for_namespace(namespace)
          for_namespace(namespace).last_fifty.find do |namespace_license|
            namespace_license.license.in_active_time?
          end
        end
      end
    end
  end
end
