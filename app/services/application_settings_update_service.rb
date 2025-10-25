# frozen_string_literal: true

class ApplicationSettingsUpdateService
  include Sagittarius::Database::Transactional

  attr_reader :current_authentication, :params

  def initialize(current_authentication, params)
    @current_authentication = current_authentication
    @params = params
  end

  def execute
    unless Ability.allowed?(current_authentication, :update_application_setting)
      return ServiceResponse.error(message: 'Missing permissions', payload: :missing_permission)
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
          author_id: current_authentication.user.id,
          entity: setting,
          details: { setting: setting.setting, value: setting.value },
          target: setting
        )
      end

      ServiceResponse.success(message: 'Settings updated', payload: ApplicationSetting.current)
    end
  end
end
