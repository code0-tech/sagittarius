# frozen_string_literal: true

FactoryBot.define do
  factory :storage_object do
    project factory: %i[namespace_project]
    file_name { 'file.txt' }
    content_type { 'text/plain' }
    byte_size { 11 }
    checksum { 'sha256:test' }
    status { :pending }
    origin { :user_upload }

    trait :committed do
      status { :committed }
      after(:build) do |storage_object|
        storage_object.blob.attach(
          io: StringIO.new('hello world'),
          filename: 'file.txt',
          content_type: 'text/plain'
        )
      end
    end
  end
end
