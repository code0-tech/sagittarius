# frozen_string_literal: true

FactoryBot.define do
  factory :translation do
    code { 'de_DE' }
    content { 'Text' }
    owner factory: :data_type
  end
end
