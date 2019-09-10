require 'rails_helper'
require 'yaml'

RSpec.configure do |config|
  # Specify a root folder where Swagger JSON files are generated
  # NOTE: If you're using the rswag-api to serve API descriptions, you'll need
  # to ensure that it's configured to serve Swagger from the same folder
  config.swagger_root = Rails.root.to_s + '/swagger'

  # load external swagger definition files
  yaml_files = [
    "spec/transfer_object/container.yml",
    "spec/transfer_object/program.yml",
    "spec/transfer_object/proxy.yml"
  ]
  yaml_hash = {}
  yaml_files.each do |path|
    yaml_hash.merge!(YAML.load(File.open(path)))
  end
  yaml_hash.deep_symbolize_keys!

  # Define one or more Swagger documents and provide global metadata for each one
  # When you run the 'rswag:specs:to_swagger' rake task, the complete Swagger will
  # be generated at the provided relative path under swagger_root
  # By default, the operations defined in spec files are added to the first
  # document below. You can override this behavior by adding a swagger_doc tag to the
  # the root example_group in your specs, e.g. describe '...', swagger_doc: 'v2/swagger.json'
  config.swagger_docs = {
    'v1/swagger.json' => {
      swagger: '2.0',
      info: {
        title: 'CloudOS API V1',
        version: 'v1'
      },
      paths: {},
      definitions: {

        success_response: {
          type: :object,
          properties: {
            status: {type: :string},
            data: {type: :object},
            message: {type: :string},
          }
        },

        error_response: {
          type: :object,
          properties: {
            status: {type: :string},
            data: {type: :object},
            message: {type: :string},
          }
        }
      }.merge!(yaml_hash)
    }
  }

  # thanks rheasunshine@github
  def no_test!

    it 'rswag ignores specs without tests, preventing them from showing in swagger doc' do |example|
      # there is an open pull request to fix this
    end
  end

  def expect_ok(json)
    expect(json[:status]).to eql("ok")
  end

  def expect_error(json)
    expect(json[:status]).to eql("error")
  end
end
