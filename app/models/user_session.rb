# frozen_string_literal: true

class UserSession < ApplicationRecord
  include TokenAttr

  token_attr :token, prefix: 's_ust_', length: 48

  belongs_to :user, inverse_of: :user_sessions
end
