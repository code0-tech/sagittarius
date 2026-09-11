# frozen_string_literal: true

module CLOUD
  module BasePolicy
    extend ActiveSupport::Concern

    prepended do
      condition(:crater_login) { authentication.crater_login? }

      rule { crater_login }.prevent_all do
        except :read_user
      end

      condition(:crater) { authentication.crater? }

      rule { crater }.prevent_all do
        except :read_namespace
        except :read_license
        except :create_license
        except :delete_license
        except :create_guest_user
      end

      # Guests never get a session today (they only exist until they complete their profile,
      # which promotes them to regular), but this keeps them locked down if that ever changes.
      condition(:guest) { user&.guest? }

      rule { guest }.prevent_all do
        except :read_user
      end
    end
  end
end
