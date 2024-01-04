# frozen_string_literal: true

module StubApplicationSettings
  def stub_application_settings(settings)
    current_settings = ApplicationSetting.current

    settings.each do |key, value|
      allow(current_settings).to receive(:[]).with(key.to_sym).and_return(value)
      allow(current_settings).to receive(:[]).with(key.to_s).and_return(value)
    end

    allow(ApplicationSetting).to receive(:current).and_return(current_settings)
  end
end

RSpec.configure do |config|
  config.include StubApplicationSettings
end
