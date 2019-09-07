class System::Container < ApplicationRecord
  enum status: [:running, :suspended, :unknown]
  has_one :program_container, :class_name => 'System::ProgramContainer', dependent: :destroy

  # create a new container record and relate it to a program
  def self.new_program_container(program_id, container_id)
    transaction do
      con = new_container(container_id)
      System::ProgramContainer.new_program_container(program_id, con.id)
      return con
    end
  end

  # create a new container record (container should already exist in docker)
  def self.new_container(container_id)
    ip = Docker::DockerService.instance.get_container_ip(container_id)

    case Docker::DockerService.instance.get_container_status(container_id)
    when "running"
      status = :running
    when "stopped"
      status = :suspended
    else
      status = :unknown
    end

    System::Container.create({container_id: container_id, status: status, ip: ip})
  end

  before_destroy do |container|
    begin
      Docker::DockerService.instance.suspend_container(container.container_id)
    rescue Timeout::TimeoutError => e
      # container did not stop in time, kill it.
      Docker::DockerService.instance.kill_container(container.container_id)
    end
    Docker::DockerService.instance.delete_container(container.container_id)
  end

end