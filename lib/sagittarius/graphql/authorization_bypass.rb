# frozen_string_literal: true

module Sagittarius
  module Graphql
    module AuthorizationBypass
      def bypass_authorization!(object, authorized: true, object_path: [])
        subject = dig_or_send_object(object, Array(object_path))

        subject&.instance_variable_set(:@sagittarius_object_authorization_bypass, authorized)

        object
      end

      def dig_or_send_object(object, object_path)
        return object if object_path.empty? || object.nil?

        current_key = object_path.shift

        if object.respond_to?(current_key)
          dig_or_send_object(object.send(current_key), object_path)
        else
          dig_or_send_object(object[current_key], object_path)
        end
      end
    end
  end
end
