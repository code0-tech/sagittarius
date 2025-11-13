# frozen_string_literal: true

module Users
  module Mfa
    module BackupCodes
      class RotateService
        include Sagittarius::Database::Transactional

        attr_reader :current_authentication, :current_user

        def initialize(current_authentication)
          @current_authentication = current_authentication
          @current_user = current_authentication.user
        end

        def execute
          unless Ability.allowed?(current_authentication, :manage_mfa, current_user)
            return ServiceResponse.error(error_code: :missing_permission)
          end

          transactional do |t|
            old_codes = BackupCode.where(user: current_user)
            old_codes.delete_all
            unless old_codes.count.zero?
              t.rollback_and_return! ServiceResponse.error(message: 'Failed to delete old backup codes',
                                                           error_code: :failed_to_invalidate_old_backup_codes)
            end

            new_codes = generate_new_codes(t)

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

        private

        def generate_new_codes(t)
          (1..10).map do |_|
            i = 0
            until (backup_code = BackupCode.create(token: SecureRandom.random_number(10**10).to_s.rjust(10, '0'),
                                                   user: current_user)).persisted?
              if i > 10
                t.rollback_and_return! ServiceResponse.error(message: 'Failed to save valid backup code',
                                                             payload: :failed_to_save_valid_backup_code)
              end
              i += 1
            end
            backup_code
          end
        end
      end
    end
  end
end
