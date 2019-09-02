require 'singleton'

class Fs::FileService
  include Singleton

  # check if the path used by the resource is empty on disk
  def is_path_empty(resource)
    !File.exist?(resource.path)
  end

  # delete any files on this resource's path
  def clear_path!(resource)
    if File.file?(resource.path)
      File.delete(resource.path)
    elsif File.directory?(resource.path)
      Dir.rmdir(resource.path)
    end
  end

  # insure the resource's path is empty
  def insure_path_empty(resource)
    unless is_path_empty(resource)
      clear_path!(resource)
    end
  end

end