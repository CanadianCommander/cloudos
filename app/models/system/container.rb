class System::Container < ApplicationRecord
  enum status: [:running, :suspended, :unknown]
  has_one :program_container, :class_name => 'System::ProgramContainer', dependent: :destroy
  has_many :container_proxies, class_name: 'System::ContainerProxy', dependent: :destroy

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

    status = Docker::DockerService.instance.get_container_status(container_id)
    System::Container.create({container_id: container_id, status: status, ip: ip})
  end

  before_destroy do |container|
    begin
      container_status = Docker::DockerService.instance.get_container_status(container.container_id)
      if container_status == :running
        begin
          Docker::DockerService.instance.suspend_container(container.container_id)
        rescue Timeout::Error => e
          # container did not stop in time, kill it.
          Docker::DockerService.instance.kill_container(container.container_id)
        end
      end

      Docker::DockerService.instance.delete_container(container.container_id)
    rescue RuntimeError => e
      # continue with the delete operation even if the docker container cannot be cleaned up, or
      # possibly does not exist / already has been deleted.
      Rails.logger.error("Error deleting docker container: #{e.to_s}\n #{e.backtrace.join("\n")}")
    end
  end

end