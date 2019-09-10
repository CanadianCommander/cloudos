require 'swagger_helper'

describe 'CloudOS API' do

  path '/api/system/containers/list' do
    get 'Get a list of all containers on the system' do
      tags 'Container'
      produces 'application/json'
      parameter name: :status, in: :query, type: :string, required: false,
                description: "Omit this parameter to search all containers.
                              If present only containers of the specified status are returned.",
                enum: [:running, :suspended]

      response '200', 'return a list of containers' do
        schema type: :object,
           properties: {
             status: {type: :string},
             data: {type: :array,
                    items: {
                      '$ref' => '#/definitions/container_to1'
                    }
             },
             message: {type: :string}
           }

        let(:status) { :running }
        run_test! do
          json = (JSON.parse response.body).deep_symbolize_keys

          expect_ok(json)
          expect(json[:data].size).to eql(3)
        end
      end

      response '400', 'status invalid' do
        schema '$ref' => '#/definitions/error_response'
        let(:status) {:fizbang}
        run_test! do
          json = (JSON.parse response.body).deep_symbolize_keys
          expect_error(json)
        end
      end
    end
  end

  path '/api/system/container/{id}' do
    get 'Get information about a container' do
      tags 'Container'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer

      response '200', 'return information about the specified container' do
        schema type: :object,
               properties: {
                 status: {type: :string},
                 data: {
                   '$ref' => '#/definitions/container_to1'
                 },
                 message: {type: :string}
               }

        let(:id) { 1 }
        run_test! do |response|
          json = (JSON.parse response.body).deep_symbolize_keys

          expect_ok(json)
          expect(json[:data][:ip]).to eql('192.168.0.2')
        end
      end

      response '400', 'no program found with the specified id' do
        schema '$ref' => '#/definitions/error_response'
        let(:id) { 42 }
        run_test! do
          json = (JSON.parse response.body).deep_symbolize_keys
          expect_error(json)
        end
      end
    end
  end

  path '/api/system/container/{id}/resume' do
    put 'resume a container' do
      tags 'Container'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer

      response '200', 'return information about the resumed container' do
        schema type: :object,
               properties: {
                 status: {type: :string},
                 data: {
                   '$ref' => '#/definitions/container_to1'
                 },
                 message: {type: :string}
               }

        no_test!
      end

      response '400', 'no program found with the specified id' do
        schema '$ref' => '#/definitions/error_response'
        let(:id) { 42 }
        run_test! do
          json = (JSON.parse response.body).deep_symbolize_keys
          expect_error(json)
        end
      end
    end
  end

  path '/api/system/container/{id}/suspend' do
    put 'suspend a container' do
      tags 'Container'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer

      response '200', 'return information about the suspended container' do
        schema type: :object,
               properties: {
                 status: {type: :string},
                 data: {
                   '$ref' => '#/definitions/container_to1'
                 },
                 message: {type: :string}
               }

        no_test!
      end

      response '400', 'no program found with the specified id' do
        schema '$ref' => '#/definitions/error_response'
        let(:id) { 42 }
        run_test! do
          json = (JSON.parse response.body).deep_symbolize_keys
          expect_error(json)
        end
      end
    end
  end

  path '/api/system/container/{id}' do
    delete 'delete a container' do
      tags 'Container'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer

      response '200', 'ok response if container successfully destroyed' do
        schema type: :object,
               properties: {
                 status: {type: :string},
                 data: {},
                 message: {type: :string}
               }

        no_test!
      end

      response '400', 'no program found with the specified id' do
        schema '$ref' => '#/definitions/error_response'
        let(:id) { 42 }
        run_test! do
          json = (JSON.parse response.body).deep_symbolize_keys
          expect_error(json)
        end
      end
    end
  end

end