require 'singleton'

class System::InstallationService
  include Singleton

  # install via git
  def git_install(program, resource, git_url)
    begin
      unless Git::GitService.instance.valid_git_url?(git_url)
        raise ArgumentError.new("Git url is invalid or cannot be reached.")
      end

      Git::GitService.instance.clone(git_url, resource.path)
      program.image_id = Docker::DockerService.instance.build_docker_image_from_src(resource.path)
      program.save!
    rescue Exception => e
      Fs::FileService.instance.delete_resource(resource)
      Docker::DockerService.instance.delete_orphan_images
      raise e
    end
  end
end