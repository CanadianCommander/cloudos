class System::ProgramContainer < ApplicationRecord
  enum status: [:running, :suspended, :unknown]
  belongs_to :program, :class_name => 'System::Program', dependent: :destroy

  # create a new container record (container should already exist in docker)
  def self.new_program_container(program_id, container_id)
    ip = Docker::DockerService.instance.get_container_ip(container_id)

    case Docker::DockerService.instance.get_container_status(container_id)
    when "running"
      status = :running
    when "stopped"
      status = :suspended
    else
      status = :unknown
    end

    System::ProgramContainer.create({program_id: program_id, container_id: container_id, status: status, ip: ip})
  end
end