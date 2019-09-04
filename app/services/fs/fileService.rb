require 'singleton'

class Fs::FileService
  include Singleton

  # check if the path used by the resource is empty on disk
  def is_path_empty(resource)
    !File.exist?(resource.path)
  end

  # delete any files on this resource's path
  def delete_resource(resource)
    if File.file?(resource.path)
      File.delete(resource.path)
    elsif File.directory?(resource.path)
      FileUtils.rm_r(resource.path)
    end
  end

  # alias to delete_resource
  def clear_path!(resource)
    delete_resource(resource)
  end

  # create the path of this resource
  def create_path(resource)
    FileUtils.mkdir_p(resource.path);
  end

  # insure the resource's path is empty
  def insure_path_empty(resource)
    if is_path_empty(resource)
      create_path(resource)
    else
      clear_path!(resource)
    end
  end

  # insure the path of this resource exists. if not create it.
  def insure_path(resource)
    if is_path_empty(resource)
      create_path(resource)
    end
  end

end