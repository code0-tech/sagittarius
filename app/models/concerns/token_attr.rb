# frozen_string_literal: true

module TokenAttr
  extend ActiveSupport::Concern

  class_methods do
    def token_attr(attribute, prefix: 'v_t_', length: 48, allow_nil: false)
      encrypts attribute, deterministic: true

      if allow_nil
        validates attribute, uniqueness: true, if: -> { send("#{attribute}?") }
      else
        validates attribute, presence: true, uniqueness: true
      end

      before_validation lambda {
        next if send("#{attribute}?")

        send("#{attribute}=", self.class.generate_token(prefix, length))
      }, if: :new_record?

      define_method("regenerate_#{attribute}!") do
        send("#{attribute}=", self.class.generate_token(prefix, length))
      end
    end

    def generate_token(prefix, length)
      "#{prefix}#{SecureRandom.base58(length - prefix.length)}"
    end
  end
end
