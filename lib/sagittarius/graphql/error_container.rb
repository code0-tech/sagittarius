# frozen_string_literal: true

module Sagittarius
  module Graphql
    ErrorContainer = Struct.new(:error_code, :details)
  end
end
