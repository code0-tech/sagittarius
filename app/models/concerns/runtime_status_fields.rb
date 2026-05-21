# frozen_string_literal: true

module RuntimeStatusFields
  extend ActiveSupport::Concern

  STATUS_TYPES = {
    unknown: 0,
    not_responding: 1,
    not_ready: 2,
    running: 3,
    stopped: 4,
  }.with_indifferent_access

  included do
    belongs_to :runtime, inverse_of: model_name.collection.to_sym

    enum :status, STATUS_TYPES, default: :unknown

    validates :identifier, presence: true,
                           allow_blank: false,
                           uniqueness: { case_sensitive: false, scope: :runtime_id }
  end
end
