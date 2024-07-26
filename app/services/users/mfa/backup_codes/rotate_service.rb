# frozen_string_literal: true

module Users
  module Mfa
    module BackupCodes
      class RotateService
        include Sagittarius::Database::Transactional

        attr_reader :current_user

        def initialize(current_user)
          @current_user = current_user
        end

        def execute
          unless Ability.allowed?(@current_user, :manage_mfa, @current_user)
            return ServiceResponse.error(payload: :missing_permission)
          end

          transactional do |t|
            old_codes = BackupCode.where(user: current_user)
            old_codes.delete_all
            unless old_codes.count.zero?
              t.rollback_and_return! ServiceResponse.error(message: 'Failed to delete old backup codes',
                                                           payload: old_codes.errors)
            end

            new_codes = (1..10).map do |_|
              until (backup_code = BackupCode.create(token: SecureRandom.random_number(10**10).to_s.rjust(10, '0'),
                                                     user: current_user)).persisted?

              end
              backup_code
            end

            AuditService.audit(
              :backup_codes_rotated,
              author_id: current_user.id,
              entity: current_user,
              details: {},
              target: current_user
            )

            ServiceResponse.success(message: 'Backup codes regenerated', payload: new_codes.map(&:token))
          end
        end
      end
    end
  end
end
