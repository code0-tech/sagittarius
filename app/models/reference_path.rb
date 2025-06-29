# frozen_string_literal: true

class ReferencePath < ApplicationRecord
  belongs_to :reference_value

  def to_grpc
    Tucana::Shared::ReferencePath.new(
      path: path,
      array_index: array_index
    )
  end
end
