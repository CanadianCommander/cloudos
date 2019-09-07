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
              items: {
                '$ref' => '#/definitions/program_to1'
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

  path '/api/system/program/{id}' do
    get 'Get information about a program' do
      tags 'Program'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer

      response '200', 'return information about the specified program' do
        schema type: :object,
          properties: {
            status: {type: :string},
            data: {
              '$ref' => '#/definitions/program_to1'
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

  path '/api/system/program/{id}/containers' do
    get "get all containers associated with this program" do
      tags 'Program'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer

      response '200', 'returns a list of containers' do
        schema type: :object,
         properties: {
           status: {type: :string},
           data: {type: :array,
                  items: {
                    '$ref' => '#/definitions/program_container_to1'
                  }
           },
           message: {type: :string}
         }


        let(:id) { 1 }
        run_test! do |res|
          json = (JSON.parse res.body).deep_symbolize_keys
          expect(json[:data].size).to eql(2)
        end
      end

      response '400', 'program id invalid' do
        schema '$ref' => '#/definitions/error_response'
        let(:id) {42}
        run_test!
      end
    end
  end

  path '/api/system/program/{id}/start' do
    post 'start a container for the given program. (i.e. start a new instance of this program)' do
      tags 'Program'
      produces 'application/json'
      consumes 'application/json'
      parameter name: :id, in: :path, type: :integer

      response '200', 'return the new container created from this program' do
        schema type: :object,
               properties: {
                 status: {type: :string},
                 data: {
                   '$ref' => '#/definitions/program_container_to1'
                 },
                 message: {type: :string}
               }
        no_test!
      end

      response '400', 'program id invalid' do
        schema '$ref' => '#/definitions/error_response'
        let(:id) {42}
        run_test!
      end
    end
  end

  path '/api/system/program/{id}/stop' do
    post 'stop all containers related to this instance' do
      tags 'Program'
      produces 'application/json'
      consumes 'application/json'
      parameter name: :id, in: :path, type: :integer

      response '200', 'Ok response if all containers destroyed' do
        schema type: :object,
               properties: {
                 status: {type: :string},
                 data: {},
                 message: {type: :string}
               }
        no_test!
      end

      response '400', 'program id invalid' do
        schema '$ref' => '#/definitions/error_response'
        let(:id) {42}
        run_test!
      end
    end
  end

  path '/api/system/program/install/git' do
    post 'install program from git by url' do
      tags 'Program'
      produces 'application/json'
      consumes 'application/json'

      parameter name: :install_params, in: :body, schema: {
          type: :object,
          properties: {
            git_url: {type: :string, description: 'The git url from which the new application will be installed'}
          }
      }

      response '200', 'return new program object' do
        schema type: :object,
           properties: {
             status: {type: :string},
             data: {
                  '$ref' => '#/definitions/program_to1'
             },
             message: {type: :string}
           }
        no_test!
      end
    end
  end


end
