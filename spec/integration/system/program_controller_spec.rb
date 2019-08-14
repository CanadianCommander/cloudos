require 'swagger_helper'

describe 'CloudOS API' do
  path '/api/system/programs/list' do
    get 'Get a list of install programs' do
      tags 'Program'
      produces 'application/json'

      response '200', 'return a list of installed programs' do
        schema type: :object,
          properties: {
            status: {type: :string},
            data: {type: :array,
              items: {type: :object,
                  properties: {
                  id: {type: :integer},
                  name: {type: :string},
                  image_id: {type: :string},
                  icon_path: {type: :string},
                  created_at: {type: :string},
                  updated_at: {type: :string}
                }
              }
            },
            message: {type: :string}
          }

        run_test! do |response|
          json = (JSON.parse response.body).deep_symbolize_keys

          expect(json[:data].count).to eql(2)
          expect(json[:data][0][:name]).to eql("appOne")
          expect(json[:data][1][:name]).to eql("appTwo")
        end
      end
    end
  end

  path '/api/system/program/{id}/info' do
    get 'Get information about a program' do
      tags 'Program'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer

      response '200', 'return information about the specified program' do
        schema type: :object,
          properties: {
            status: {type: :string},
            data: {type: :object,
                properties: {
                id: {type: :integer},
                name: {type: :string},
                image_id: {type: :string},
                icon_path: {type: :string},
                created_at: {type: :string},
                updated_at: {type: :string}
              }
            },
            message: {type: :string}
          }

        let(:id) { 1 }
        run_test! do |response|
          json = (JSON.parse response.body).deep_symbolize_keys

          expect(json[:data][:name]).to eql('appOne')
        end
      end

      response '400', 'no program found with the specified id' do
        schema '$ref' => '#/definitions/error_response'
        let(:id) { 4 }
        run_test!
      end
    end
  end
end
