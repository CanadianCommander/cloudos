require 'singleton'

class System::ContainerService
  include Singleton

  def initialize
    super

    @docker_service = Docker::DockerService.instance
  end

  # create a new container for the specified program
  def create_container(program)
    container_id = @docker_service.create_container(program.image_id)
    System::Container.new_program_container(program.id, container_id)
  end

end