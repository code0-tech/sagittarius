# frozen_string_literal: true

module Sagittarius
  # Computes monthly billing-cycle ranges anchored to an arbitrary day-of-month (typically a
  # license's start_date), rather than the calendar month. E.g. an anchor of the 15th means
  # cycles run 15th-to-14th, not 1st-to-end-of-month.
  module BillingCycle
    module_function

    def range_for(anchor_date, reference: Date.current)
      cycle_start = clamp_to_month(reference, anchor_date.day)
      cycle_start = cycle_start.advance(months: -1) if cycle_start > reference

      cycle_start..(cycle_start.advance(months: 1) - 1)
    end

    def next_reset_date(anchor_date, reference: Date.current)
      range_for(anchor_date, reference: reference).end + 1
    end

    def clamp_to_month(date, day)
      last_day_of_month = Date.new(date.year, date.month, -1).day
      Date.new(date.year, date.month, [day, last_day_of_month].min)
    end
  end
end
