# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Graphql' do
  include GraphqlHelpers

  let(:echo_message) { 'query test' }
  let(:query) do
    <<~QUERY
      query {
        echo(message: "#{echo_message}")
      }
    QUERY
  end
  let(:authorization) { nil }
  let(:headers) { { authorization: authorization } }

  before do
    post_graphql query, headers: headers
  end

  context 'without authorization' do
    it 'resolves the query', :aggregate_failures do
      expect(response).to have_http_status(:ok)

      expect_graphql_errors_to_be_empty
      expect(graphql_data_at(:echo)).to eq(echo_message)
    end

    context 'when using mutations' do
      let(:query) do
        <<~QUERY
          mutation {
            echo(input: { message: "#{echo_message}" }) {
              message
            }
          }
        QUERY
      end

      it 'denies access' do
        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'when using mutations allowed for anonymous users' do
      let(:query) do
        <<~QUERY
          mutation {
            usersLogin(input: {
              email: ""
              password: ""
            }) {
              errors
            }
          }
        QUERY
      end

      it 'resolves the query', :aggregate_failures do
        expect(response).to have_http_status(:ok)

        expect_graphql_errors_to_be_empty
        expect(graphql_data_at(:users_login, :errors)).to be_present
      end

      context 'when aliasing the mutation' do
        let(:query) do
          <<~QUERY
            mutation {
              login: usersLogin(input: {
                email: ""
                password: ""
              }) {
                errors
              }
            }
          QUERY
        end

        it 'resolves the query', :aggregate_failures do
          expect(response).to have_http_status(:ok)

          expect_graphql_errors_to_be_empty
          expect(graphql_data_at(:login, :errors)).to be_present
        end
      end

      context 'when using multiple mutations' do
        let(:query) do
          <<~QUERY
            mutation {
              usersLogin(input: {
                email: ""
                password: ""
              }) {
                errors
              }
              usersRegister(input: {
                username: ""
                email: ""
                password: ""
              }) {
                errors
              }
            }
          QUERY
        end

        it 'denies access' do
          expect(response).to have_http_status(:forbidden)
        end
      end

      context 'when aliasing mutation as allowed mutation' do
        let(:query) do
          <<~QUERY
            mutation {
              usersLogin: echo(message: "#{echo_message}")
            }
          QUERY
        end

        it 'denies access' do
          expect(response).to have_http_status(:forbidden)
        end
      end
    end
  end

  context 'with valid authorization' do
    let(:user_session) { create(:user_session) }
    let(:authorization) { "Session #{user_session.token}" }

    it 'resolves the query', :aggregate_failures do
      expect(response).to have_http_status(:ok)

      expect_graphql_errors_to_be_empty
      expect(graphql_data_at(:echo)).to eq(echo_message)
    end

    context 'when using mutations' do
      let(:query) do
        <<~QUERY
          mutation {
            echo(input: { message: "#{echo_message}" }) {
              message
            }
          }
        QUERY
      end

      it 'resolves the query', :aggregate_failures do
        expect(response).to have_http_status(:ok)

        expect_graphql_errors_to_be_empty
        expect(graphql_data_at(:echo, :message)).to eq(echo_message)
      end
    end
  end

  context 'with invalid authorization' do
    let(:authorization) { 'blub' }

    it 'returns unauthorized', :aggregate_failures do
      expect(response).to have_http_status(:unauthorized)
      expect(response.body).to be_empty
    end
  end
end
