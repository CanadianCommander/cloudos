require 'swagger_helper'

describe 'CloudOS API' do

  path '/api/system/proxies/list' do
    get 'Get a list of all proxies on the system' do
      tags 'Proxy'
      produces 'application/json'

      response '200', 'return a list of proxies' do
        schema type: :object,
               properties: {
                 status: {type: :string},
                 data: {type: :array,
                        items: {
                          '$ref' => '#/definitions/proxy_to1'
                        }
                 },
                 message: {type: :string}
               }

        run_test! do
          json = (JSON.parse response.body).deep_symbolize_keys

          expect_ok(json)
          expect(json[:data].size).to eql(1)
        end
      end
    end
  end

  path '/api/system/proxy/' do
    post 'create a new proxy' do
      tags 'Proxy'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :proxy_def, in: :body, schema: {
        type: :object,
        properties: {
          int_port: {type: :integer},
          ip: {type: :string},
          proto: {type: :string},
          type: {type: :type},
        }
      }

      response '200', 'return the newly created proxy' do
        schema type: :object,
              properties: {
                status: {type: :string},
                data: {
                  '$ref' => '#/definitions/proxy_to1'
                },
                message: {type: :string}
              }

        let(:proxy_def) {
          {
            int_port: 80,
            ip: "172.0.0.1",
            proto: :http,
            type: :static
          }
        }
        run_test! do
          json = (JSON.parse response.body).deep_symbolize_keys

          expect_ok(json)
          expect(json[:data][:internal_ip]).to eql("172.0.0.1")
        end
      end
    end
  end

  path '/api/system/proxy/container' do
    post 'create a new proxy for the specified container. This proxy is linked to the container and will be deleted if the container is deleted' do
      tags 'Proxy'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :proxy_def, in: :body, schema: {
        type: :object,
        properties: {
          int_port: {type: :integer},
          container_id: {type: :integer},
          proto: {type: :string},
          type: {type: :type},
        }
      }

      response '200', 'return the newly created proxy' do
        schema type: :object,
               properties: {
                 status: {type: :string},
                 data: {
                   '$ref' => '#/definitions/proxy_to1'
                 },
                 message: {type: :string}
               }

        let(:proxy_def) {
          {
            int_port: 80,
            container_id: 1,
            proto: :http,
            type: :static
          }
        }
        run_test! do
          json = (JSON.parse response.body).deep_symbolize_keys

          expect_ok(json)
          expect(json[:data][:internal_ip]).to eql("192.168.0.2")
        end
      end
    end
  end

  path '/api/system/proxy/{id}' do
    get 'get a proxy' do
      tags 'Proxy'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer

      response '200', 'return the proxy' do
        schema type: :object,
               properties: {
                 status: {type: :string},
                 data: {
                   '$ref' => '#/definitions/proxy_to1'
                 },
                 message: {type: :string}
               }

        let(:id) {1}
        run_test! do
          json = (JSON.parse response.body).deep_symbolize_keys

          expect_ok(json)
          expect(json[:data][:internal_ip]).to eql("172.0.0.2")
        end
      end

      response '400', 'invalid proxy id' do
        schema '$ref' => '#/definitions/error_response'
        let(:id) { 42 }
        run_test! do
          json = (JSON.parse response.body).deep_symbolize_keys
          expect_error(json)
        end
      end
    end
  end

  path '/api/system/proxy/{id}' do
    put 'update a proxy' do
      tags 'Proxy'
      produces 'application/json'
      consumes 'application/json'
      parameter name: :id, in: :path, type: :integer

      parameter name: :proxy_def, in: :body, schema: {
        type: :object,
        properties: {
          int_port: {type: :integer, required: false},
          ip: {type: :string, required: false},
          proto: {type: :string, required: false},
          type: {type: :type, required: false},
          ttl: {type: :integer, required: false}
        }
      }

      response '200', 'return the updated proxy' do
        schema type: :object,
               properties: {
                 status: {type: :string},
                 data: {
                   '$ref' => '#/definitions/proxy_to1'
                 },
                 message: {type: :string}
               }

        let(:id) {1}
        let(:proxy_def) {
          {
            ip: "8.8.8.8"
          }
        }
        run_test! do
          json = (JSON.parse response.body).deep_symbolize_keys

          expect_ok(json)
          expect(json[:data][:internal_ip]).to eql("8.8.8.8")
        end
      end

      response '400', 'invalid proxy id' do
        schema '$ref' => '#/definitions/error_response'
        let(:id) { 42 }
        let(:proxy_def) {
          {
            ip: "8.8.8.8"
          }
        }
        run_test! do
          json = (JSON.parse response.body).deep_symbolize_keys
          expect_error(json)
        end
      end
    end
  end

  path '/api/system/proxy/{id}' do
    delete 'delete a proxy' do
      tags 'Proxy'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer

      response '200', 'return Ok' do
        schema type: :object,
               properties: {
                 status: {type: :string},
                 data: {},
                 message: {type: :string}
               }

        let(:id) {1}
        run_test! do
          json = (JSON.parse response.body).deep_symbolize_keys
          expect_ok(json)
        end
      end

      response '400', 'invalid proxy id' do
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