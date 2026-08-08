# frozen_string_literal: true

module TruncateTimePrecision
  extend ActiveSupport::Concern

  class_methods do
    def truncate_time_precision(*attributes)
      before_create lambda {
        attributes.each do |attribute|
          value = self[attribute] || Time.zone.now

          self[attribute] = value.change(usec: 0)
        end
      }

      before_update lambda {
        attributes.each do |attribute|
          next unless attribute_changed?(attribute)

          value = self[attribute]
          next unless value.respond_to?(:change)

          self[attribute] = value.change(usec: 0)
        end
      }
    end
  end
end
