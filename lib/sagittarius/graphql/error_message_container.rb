# frozen_string_literal: true

module Sagittarius
  module Graphql
    ErrorMessageContainer = Struct.new(:message)
    ServiceResponseErrorContainer = Struct.new(:error_code)
  end
end
