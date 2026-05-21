# frozen_string_literal: true

class ActionStatus < ApplicationRecord
  include RuntimeStatusFields

  has_many :action_status_configurations, inverse_of: :action_status, dependent: :destroy

  def configurations
    action_status_configurations
  end
end
