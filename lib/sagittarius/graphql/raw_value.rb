# frozen_string_literal: true

module Sagittarius
  module Graphql
    # Wraps a raw JSON success value so the NodeExecutionSuccess union can tell it apart
    # from a persisted sub-flow function result (which is itself a JSON object). A union
    # member must be an object type, so the JSON itself is exposed through its `value` field.
    RawValue = Struct.new(:value)
  end
end
