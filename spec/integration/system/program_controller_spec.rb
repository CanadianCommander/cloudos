require 'swagger_helper'

describe 'CloudOS API' do
  path '/api/system/programs/list' do
    get 'Gets all install programs' do
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
end
