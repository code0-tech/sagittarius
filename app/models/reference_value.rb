# frozen_string_literal: true

class ReferenceValue < ApplicationRecord
  belongs_to :node_function # real value association
  has_many :reference_paths, inverse_of: :reference_value
  has_many :node_parameters, inverse_of: :reference_value

  def to_grpc
    Tucana::Shared::ReferenceValue.new(
      node_id: node_function.id,
      paths: reference_paths.map(&:to_grpc)
    )
  end
end
