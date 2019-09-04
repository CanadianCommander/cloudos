require 'singleton'

class System::InstallationService
  include Singleton

  # install via git
  def git_install(program, resource, git_url)
    begin
      res = Util.cmd("git clone #{git_url} #{resource.path}")

      program.image_id = Docker::DockerService.instance.build_image_from_docker_file(resource.path)
      program.save!
    rescue Exception => e
      Fs::FileService.instance.delete_resource(resource)
      Docker::DockerService.instance.delete_orphan_images
      raise e
    end
  end
end