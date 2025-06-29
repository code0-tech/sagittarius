# frozen_string_literal: true

class ReferenceValue < ApplicationRecord
  belongs_to :data_type_identifier
  has_many :reference_paths, inverse_of: :reference_value
  has_many :node_parameters, inverse_of: :reference_value

  def to_grpc
    Tucana::Shared::ReferenceValue.new(
      data_type_identifier: data_type_identifier.to_grpc,
      primary_level: primary_level,
      secondary_level: secondary_level,
      tertiary_level: tertiary_level,
      path: reference_paths.map(&:to_grpc)
    )
  end
end
