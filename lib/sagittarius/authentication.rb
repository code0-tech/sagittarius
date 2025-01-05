# frozen_string_literal: true

module Sagittarius
  Authentication = Struct.new(:type, :authentication) do
    def mutations_allowed?
      return true if session?

      false
    end

    def invalid?
      (authentication.nil? && !none?) || type == :invalid
    end

    %i[none session].each do |t|
      define_method :"#{t}?" do
        type == t
      end
    end

    def user
      authentication&.user
    end

    # for declarative-policy output
    def to_reference
      "<#{self.class.name} type=#{type} authentication=#{authentication.inspect}>"
    end
  end
end
