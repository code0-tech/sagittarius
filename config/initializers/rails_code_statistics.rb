# frozen_string_literal: true

return unless defined?(Rails::Command::StatsCommand)

Rails::CodeStatistics.directories.clear
Rails::CodeStatistics.test_types.clear

%w[Controllers Finders GraphQL GRPC Jobs Mailers Models Policies Services].each do |type|
  Rails::CodeStatistics.register_directory(type, "app/#{type.downcase}")
end

%w[Config DB Lib Tooling].each do |type|
  Rails::CodeStatistics.register_directory(type, type.downcase)
end

%w[Config Finders GraphQL GRPC Lib Models Policies Requests Services Tooling].each do |type|
  Rails::CodeStatistics.register_directory("#{type} specs", "spec/#{type.downcase}", test_directory: true)
end

%w[factories support].each do |type|
  Rails::CodeStatistics.register_directory("Spec #{type}", "spec/#{type}", test_directory: true)
end
