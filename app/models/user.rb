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
  validates :totp_secret, length: { maximum: 32 }

  has_many :backup_codes, inverse_of: :user

  has_many :user_sessions, inverse_of: :user
  has_many :authored_audit_events, class_name: 'AuditEvent', inverse_of: :author

  has_many :namespace_memberships, class_name: 'NamespaceMember', inverse_of: :user
  has_many :namespaces, through: :namespace_memberships, inverse_of: :users

  def mfa_enabled?
    totp_secret != nil
  end
end
