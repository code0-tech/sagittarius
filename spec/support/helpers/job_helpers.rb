# frozen_string_literal: true

module JobHelpers
  def queue_adapter_for_test
    GoodJob::Adapter.new(execution_mode: :inline)
  end
end
