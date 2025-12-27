# frozen_string_literal: true

class RuntimeStatus < ApplicationRecord
  belongs_to :runtime, inverse_of: :runtime_statuses
  has_many :runtime_status_configurations, inverse_of: :runtime_status

  STATUS_TYPES = {
    not_responding: 0,
    not_ready: 1,
    running: 2,
    stopped: 3,
  }.with_indifferent_access

  enum :status, STATUS_TYPES, default: :stopped

  STATUS_TYPE_TYPES = {
    adapter: 0,
    execution: 1,
  }.with_indifferent_access

  enum :status_type, STATUS_TYPE_TYPES

  validates :identifier, presence: true,
                         allow_blank: false,
                         uniqueness: { case_sensitive: false, scope: :runtime_id }

  validate :runtime_status_informations_only_for_adapter

  private

  def runtime_status_informations_only_for_adapter
    return if adapter?
    return if runtime_status_configurations.empty?

    errors.add(:runtime_status_informations, :only_allowed_for_adapters)
  end
end
