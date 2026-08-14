# frozen_string_literal: true

# Shared oneof behaviour for records that hold a `Tucana::Shared::NodeValue`:
# a `literal_value` column plus a `reference_value` and `sub_flow` association,
# of which at most one may be present.
module NodeValueOwner
  extend ActiveSupport::Concern

  included do
    has_one :reference_value, autosave: true
    has_one :sub_flow, autosave: true

    validate :only_one_value_present
  end

  # The record itself represents the literal branch, so it can be passed
  # straight to NodeParameterValueType/InlineReferenceValueType for GraphQL union resolution.
  def value_variant
    if reference_value.present?
      reference_value
    elsif sub_flow.present?
      sub_flow
    else
      self
    end
  end

  private

  def only_one_value_present
    values = [!literal_value.nil?, reference_value.present?, sub_flow.present?]
    return if values.count(true) <= 1

    errors.add(:value, 'Only one of literal_value, reference_value, or sub_flow must be present')
  end
end
