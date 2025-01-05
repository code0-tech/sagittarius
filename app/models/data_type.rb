# frozen_string_literal: true

class DataType < ApplicationRecord
  VARIANTS = {
    primitive: 1,
    type: 2,
    object: 3,
    datatype: 4,
    array: 5,
  }.with_indifferent_access

  enum :variant, VARIANTS, prefix: :variant

  belongs_to :parent_type, class_name: 'DataType', inverse_of: :child_types, optional: true
  belongs_to :namespace, inverse_of: :data_types, optional: true

  has_many :child_types, class_name: 'DataType', inverse_of: :parent_type
  has_many :translations, class_name: 'Translation', as: :owner
  has_many :rules, class_name: 'DataTypeRule', inverse_of: :data_type

  validates :variant, presence: true,
                      inclusion: {
                        in: VARIANTS.keys.map(&:to_s),
                      }

  validate :validate_recursion, if: :parent_type_changed?

  def validate_recursion
    current_type = self
    until current_type.parent_type.nil?
      current_type = current_type.parent_type

      if current_type == self
        errors.add(:parent_type, :recursion)
        break
      end
    end
  end
end
