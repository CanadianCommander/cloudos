require 'singleton'

class System::InstallationService
  include Singleton

  # install via git
  def git_install(program, resource, git_url)
    begin
      begin
        Util.cmd("git", "ls-remote", "-h", git_url)
      rescue RuntimeError => e
        raise ArgumentError.new("Git url is invalid or cannot be reached.")
      end

      res = Util.cmd("git", "clone", git_url, resource.path)

      program.image_id = Docker::DockerService.instance.build_image_from_docker_file(resource.path)
      program.save!
    rescue Exception => e
      Fs::FileService.instance.delete_resource(resource)
      Docker::DockerService.instance.delete_orphan_images
      raise e
    end
  end
end