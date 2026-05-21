# frozen_string_literal: true

class ActionStatusConfiguration < ApplicationRecord
  belongs_to :action_status, inverse_of: :action_status_configurations
end
