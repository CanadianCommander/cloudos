require 'swagger_helper'

describe 'CloudOS API', :auth do

  path '/api/auth/token' do
    post 'Get an API token.' do
      tags 'Auth'
      produces 'application/json'

      parameter name: :Authorization, in: :header, type: :string, required: false,
                description: "Encoded authentication string like, \" Basic bWVAYmJlbmV0dGkuY2E6Y2xvdWRvcw==\""

      response '200', 'return a new token' do
        schema type: :object,
               properties: {
                 status: {type: :string},
                 data: {
                          '$ref' => '#/definitions/api_session_to1'
                 },
                 message: {type: :string}
               }

        let(:Authorization){" Basic bWVAYmJlbmV0dGkuY2E6Y2xvdWRvcw=="}
        run_test! do
          json = (JSON.parse response.body).deep_symbolize_keys
          expect_ok(json)
        end
      end

      response '401', 'Not Authorized' do
        schema '$ref' => '#/definitions/error_response'
        let(:Authorization) {" Basic bWVAYmJlbmV0dGkuY2E6Y2xvdWRvczM="}
        run_test! do
          json = (JSON.parse response.body).deep_symbolize_keys
          expect_error(json)
        end
      end
    end
  end


end