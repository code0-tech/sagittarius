# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  validates :username, length: { maximum: 50 },
                       presence: true,
                       allow_blank: false,
                       uniqueness: { case_sensitive: false }
  validates :email, length: { maximum: 255 },
                    format: { with: URI::MailTo::EMAIL_REGEXP },
                    presence: true,
                    allow_blank: false,
                    uniqueness: { case_sensitive: false }

  has_many :team_members, inverse_of: :user
end
