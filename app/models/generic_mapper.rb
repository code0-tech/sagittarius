# frozen_string_literal: true

class GenericMapper < ApplicationRecord
  belongs_to :generic_type, inverse_of: :generic_mappers, optional: true
  belongs_to :source, class_name: 'DataTypeIdentifier', inverse_of: :generic_mappers
  belongs_to :runtime, inverse_of: :generic_mappers
  belongs_to :runtime_parameter_definition, optional: true, inverse_of: :generic_mappers

  validates :target, presence: true

  def to_grpc
    Tucana::Shared::GenericMapper.new(
      data_type_identifier_id: data_type_identifier&.to_grpc,
      generic_key: generic_key,
      target: target
    )
  end
end
