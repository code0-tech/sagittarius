# frozen_string_literal: true

module RuntimeUsage
  Bucket = Struct.new(:period_start, :period_end, :usage, :value, keyword_init: true)
end
