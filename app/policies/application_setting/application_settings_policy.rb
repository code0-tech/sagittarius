# frozen_string_literal: true

class ApplicationSetting
  class ApplicationSettingsPolicy < BasePolicy
    delegate { :global }
  end
end
