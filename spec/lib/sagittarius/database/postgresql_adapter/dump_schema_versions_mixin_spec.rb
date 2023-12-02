# frozen_string_literal: true

# Heavily inspired by the implementation of GitLab
# (https://gitlab.com/gitlab-org/gitlab/-/blob/7983d2a2203aff265fae479d7c1b7066858d1265/spec/lib/gitlab/database/postgresql_adapter/dump_schema_versions_mixin_spec.rb)
# which is licensed under a modified version of the MIT license which can be found at
# https://gitlab.com/gitlab-org/gitlab/-/blob/7983d2a2203aff265fae479d7c1b7066858d1265/LICENSE
#
# The code might have been modified to accommodate for the needs of this project

require 'rails_helper'

RSpec.describe Sagittarius::Database::PostgresqlAdapter::DumpSchemaVersionsMixin do
  let(:instance_class) do
    klass = Class.new do
      def dump_schema_information
        original_dump_schema_information
      end

      def original_dump_schema_information; end
    end

    klass.prepend(described_class)

    klass
  end

  let(:instance) { instance_class.new }

  it 'calls SchemaMigrations touch_all and skips original implementation', :aggregate_failures do
    allow(Sagittarius::Database::SchemaMigrations).to receive(:touch_all)
    allow(instance).to receive(:original_dump_schema_information)

    instance.dump_schema_information

    expect(Sagittarius::Database::SchemaMigrations).to have_received(:touch_all).with(instance)
    expect(instance).not_to have_received(:original_dump_schema_information)
  end

  it 'does not call touch_all in production' do
    allow(Rails).to receive(:env).and_return(ActiveSupport::StringInquirer.new('production'))
    allow(Sagittarius::Database::SchemaMigrations).to receive(:touch_all)

    instance.dump_schema_information

    expect(Sagittarius::Database::SchemaMigrations).not_to have_received(:touch_all)
  end
end
