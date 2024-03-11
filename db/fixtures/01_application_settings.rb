# frozen_string_literal: true

ApplicationSetting.seed_once :setting do |s|
  s.setting = :user_registration_enabled
  s.value = true
end

ApplicationSetting.seed_once :setting do |s|
  s.setting = :organization_creation_restricted
  s.value = false
end
