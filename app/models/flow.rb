# frozen_string_literal: true

class Flow < ApplicationRecord
  VALIDATION_STATUS = {
    unvalidated: 0,
    valid: 1,
    invalid: 2,
  }.with_indifferent_access

  DISABLED_REASON = {
    _dummy: { db: 0, description: 'Dummy value' }, # temporary until the first real disabled reason gets introduced
  }.with_indifferent_access

  belongs_to :project, class_name: 'NamespaceProject'
  belongs_to :flow_type
  belongs_to :starting_node, class_name: 'NodeFunction', optional: true

  enum :validation_status, VALIDATION_STATUS, prefix: :validation_status
  enum :disabled_reason, DISABLED_REASON.transform_values { |v| v[:db] }, prefix: :disabled_reason

  has_many :flow_settings, class_name: 'FlowSetting', inverse_of: :flow
  has_many :node_functions, class_name: 'NodeFunction', inverse_of: :flow

  has_many :flow_data_type_links, inverse_of: :flow
  has_many :referenced_data_types, through: :flow_data_type_links, source: :referenced_data_type

  validates :validation_status,
            presence: true,
            inclusion: {
              in: VALIDATION_STATUS.keys.map(&:to_s),
            }

  validates :disabled_reason,
            inclusion: {
              in: DISABLED_REASON.keys.map(&:to_s),
            },
            if: :disabled?

  validates :name, presence: true,
                   allow_blank: false,
                   uniqueness: { case_sensitive: false, scope: :project_id }

  validates :signature, presence: true, length: { maximum: 500 }

  scope :enabled, -> { where(disabled_reason: nil) }
  scope :disabled, -> { where.not(disabled_reason: nil) }

  def disabled?
    disabled_reason.present?
  end

  def to_grpc
    Tucana::Shared::ValidationFlow.new(
      flow_id: id,
      project_id: project.id,
      project_slug: project.slug,
      type: flow_type.identifier,
      data_types: [], # TODO: when data types are creatable
      disable_reason: disabled_reason,
      settings: flow_settings.map(&:to_grpc),
      starting_node_id: starting_node.id,
      node_functions: node_functions.map(&:to_grpc),
      signature: signature
    )
  end
end
