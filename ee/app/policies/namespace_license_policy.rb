# frozen_string_literal: true

class NamespaceLicensePolicy < BasePolicy
  delegate { @subject.namespace }
end
