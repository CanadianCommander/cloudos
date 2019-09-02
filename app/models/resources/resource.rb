class Resources::Resource < ApplicationRecord
  enum type: {
    APPLICATION: 0
  }

  def self.new_resource(path, type)
    resource = Resources::Resource.new
    resource.path = path
    resource.type = type
    return resource
  end
end
