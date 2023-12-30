# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Sagittarius::Graphql::AuthorizationBypass do
  let_it_be(:clazz) do
    Class.new do
      include Sagittarius::Graphql::AuthorizationBypass
    end
  end

  def expect_authorization_bypass(object)
    expect(object.instance_variable_get(:@sagittarius_object_authorization_bypass)).to be true
  end

  it 'marks the object for authorization bypass' do
    some_object = {}

    clazz.new.bypass_authorization! some_object

    expect_authorization_bypass some_object
  end

  it 'marks nested objects for authorization bypass' do
    some_inner_object = {}
    some_object = { some_key: some_inner_object }

    clazz.new.bypass_authorization! some_object, object_path: :some_key

    expect_authorization_bypass some_inner_object
  end

  it 'marks multiple nested objects for authorization bypass' do
    some_inner_object = {}
    some_object = { some_key: { some_inner_key: some_inner_object } }

    clazz.new.bypass_authorization! some_object, object_path: %i[some_key some_inner_key]

    expect_authorization_bypass some_inner_object
  end

  it 'marks nested objects with methods for authorization bypass' do
    some_inner_object = {}
    some_object = Class.new do
      def initialize(inner_object) = @inner_object = inner_object
      def some_method = @inner_object
    end.new(some_inner_object)

    clazz.new.bypass_authorization! some_object, object_path: :some_method

    expect_authorization_bypass some_inner_object
  end
end
