# frozen_string_literal: true

module Usage
  Bucket = Struct.new(:period_start, :period_end, :execution_count, :total_execution_time, keyword_init: true)
end
