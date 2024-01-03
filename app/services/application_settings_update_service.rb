# frozen_string_literal: true

class ApplicationSettingsUpdateService
  include Sagittarius::Database::Transactional

  attr_reader :current_user, :params

  def initialize(current_user, params)
    @current_user = current_user
    @params = params
  end

  def execute
    unless Ability.allowed?(current_user, :update_application_setting)
      return ServiceResponse.error(message: 'Missing permissions', payload: :permission_missing)
    end

    transactional do |t|
      params.each do |param, value|
        setting = ApplicationSetting.find_by(setting: param)
        if setting.blank?
          t.rollback_and_return! ServiceResponse.error(message: 'Invalid setting', payload: :invalid_setting)
        end

        setting.value = value
        unless setting.save
          t.rollback_and_return! ServiceResponse.error(message: 'Failed to update setting', payload: setting.errors)
        end

        AuditService.audit(
          :application_setting_updated,
          author_id: current_user.id,
          entity: setting,
          details: { setting: setting.setting, value: setting.value },
          target: setting
        )
      end

      ServiceResponse.success(message: 'Settings updated', payload: ApplicationSetting.current)
    end
  end
end
