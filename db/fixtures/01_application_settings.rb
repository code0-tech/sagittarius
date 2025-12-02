# frozen_string_literal: true

ApplicationSetting.seed_once :setting do |s|
  s.setting = :user_registration_enabled
  s.value = true
end

ApplicationSetting.seed_once :setting do |s|
  s.setting = :organization_creation_restricted
  s.value = false
end

ApplicationSetting.seed_once :setting do |s|
  s.setting = :identity_providers
  s.value = []
end

ApplicationSetting.seed_once :setting do |s|
  s.setting = :admin_status_visible
  s.value = true
end

ApplicationSetting.seed_once :setting do |s|
  s.setting = :terms_and_conditions_url
  s.value = nil
end

ApplicationSetting.seed_once :setting do |s|
  s.setting = :privacy_url
  s.value = nil
end

ApplicationSetting.seed_once :setting do |s|
  s.setting = :legal_notice_url
  s.value = nil
end
