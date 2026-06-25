# frozen_string_literal: true

class User < ApplicationRecord
  include NamespaceParent

  GHOST_USERNAME = 'ghost'
  GHOST_EMAIL = 'ghost@code0.tech'

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

  has_many :user_identities, inverse_of: :user

  has_one_attached :avatar

  before_destroy :prevent_destroy_ghost_user, prepend: true
  before_destroy :reassign_authored_audit_events_to_ghost_user

  def self.ghost
    find_by!(username: GHOST_USERNAME)
  end

  def ghost?
    username == GHOST_USERNAME
  end

  def mfa_enabled?
    totp_secret != nil
  end

  def admin?
    admin
  end

  def blocked?
    blocked_at.present?
  end

  def validate_mfa!(mfa)
    mfa_passed = false
    mfa_type = mfa&.[](:type)
    mfa_value = mfa&.[](:value)

    case mfa_type
    when :backup_code
      backup_code = BackupCode.where(user: self, token: mfa_value)
      mfa_passed = backup_code.any?
      backup_code.delete_all
      mfa_passed = false unless backup_code.none?
    when :totp
      totp = ROTP::TOTP.new(totp_secret)
      mfa_passed = totp.verify(mfa_value)
    end
    [mfa_passed, mfa_type]
  end

  generates_token_for :email_verification, expires_in: 15.minutes do
    email
  end

  generates_token_for :password_reset, expires_in: 15.minutes do
    password_digest&.last(20)
  end

  private

  def prevent_destroy_ghost_user
    return unless ghost?

    errors.add(:base, :invalid, message: 'Cannot delete ghost user')
    throw :abort
  end

  def reassign_authored_audit_events_to_ghost_user
    ghost_user = self.class.ghost

    authored_audit_events.find_each do |audit_event|
      audit_event.update!(author: ghost_user)
    end
  end
end

User.prepend_extensions
