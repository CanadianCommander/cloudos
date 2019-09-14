class Resources::Resource < ApplicationRecord
  def self.new_resource(path, type)
    resource = Resources::Resource.create(path: path, type: type)
    return resource
  end

  before_destroy do |resource|
    Fs::FileService.instance.delete_resource(resource)
  end
end
