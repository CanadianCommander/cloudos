require 'singleton'

class System::ContainerService
  include Singleton

  def initialize
    super

    @docker_service = Docker::DockerService.instance
  end

  # get the container with id == id
  def get_container(id)
    System::Container.find(id)
  end

  # gets all containers with optional status filter
  def all_containers(status=-1)
    if status == -1
      return System::Container.all
    else
      return System::Container.where(status: status)
    end
  end

  # create a new container for the specified program
  def create_container(program)
    container_id = @docker_service.create_container(program.image_id)
    System::Container.new_program_container(program.id, container_id)
  end

  # destroy the container with the given id
  def destroy_container(id)
    get_container(id).destroy
  end

  def suspend_container(container)
    @docker_service.suspend_container(container.container_id)
    container.status = :suspended
    container.save!
  end

  def resume_container(container)
    @docker_service.resume_container(container.container_id)
    container.status = :running
    container.save!
  end
end