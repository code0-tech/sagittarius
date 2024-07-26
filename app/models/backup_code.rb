# frozen_string_literal: true

class BackupCode < ApplicationRecord
  belongs_to :user, inverse_of: :backup_codes

  validates :token, presence: true,
                    length: { minimum: 10, maximum: 10 },
                    allow_blank: false,
                    uniqueness: { case_sensitive: false, scope: :user_id }
end
