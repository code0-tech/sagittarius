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

  validates :firstname, length: { maximum: 50 }
  validates :lastname, length: { maximum: 50 }

  has_many :user_sessions, inverse_of: :user
  has_many :authored_audit_events, class_name: 'AuditEvent', inverse_of: :author

  has_many :team_memberships, class_name: 'TeamMember', inverse_of: :user
  has_many :teams, through: :team_memberships, inverse_of: :users
end
