# frozen_string_literal: true

module Types
  class UsageAggregationEnum < Types::BaseEnum
    description 'Granularity to bucket execution usage into.'

    value 'DAY', 'Bucket usage per day.', value: 'day'
    value 'WEEK', 'Bucket usage per ISO week.', value: 'week'
    value 'MONTH', 'Bucket usage per calendar month.', value: 'month'
  end
end
