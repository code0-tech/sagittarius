module Users
  module Identity
    class BaseService

      def identity_provider
        identity_provider = Code0::Identities::IdentityProvider.new
        enabled_providers = ApplicationSetting.current[:identity_providers]
        enabled_providers.each do |provider|
          identity_provider.add_named_provider(provider[:id], provider[:type], -> { provider[:config] })
        end
        identity_provider
      end

    end
  end
end
