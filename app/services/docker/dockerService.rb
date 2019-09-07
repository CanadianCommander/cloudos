require 'singleton'

class Docker::DockerService
  include Singleton

  #========================== IMAGE ==================================#

  # builds a new docker image from the specified directory and return new image id
  def build_docker_image_from_src (docker_path)
    docker_image_id = Util.cmd("docker", "build", docker_path, "--force-rm=true", "--quiet").match(/:([\d\w]*)/)
    unless docker_image_id.nil? || docker_image_id.size < 2
      return docker_image_id[1]
    end

    raise RuntimeError.new("Could not retrieve docker image id")
  end

  def get_all_image_ids
    ids = Util.cmd("docker", "images", "--all", "--quiet", "--no-trunc").split("\n")
  end

  def delete_image(image_id)
    Util.cmd("docker", "image", "rm", image_id)
  end

  def delete_orphan_images
    image_ids = get_all_image_ids
    System::Program.all.each do |program|
      image_ids.delete(program.image_id)
    end

    # any images left in image_ids are orphans
    image_ids.each do |image|
      unless image.nil?
        begin
          delete_image(image)
        rescue RuntimeError => e
          # images often cascade delete so when deleting we
          # will often get image does not exists error. just suppress.
        end
      end
    end
  end

  #========================== CONTAINER ===============================#

  # create a new container from this image and returns the container id.
  def create_container (image_id)
    Util.cmd("docker", "run", "-d", image_id).strip
  end

  # delete a container
  def delete_container (container_id)
    Util.cmd("docker", "container", "rm", container_id).strip
  end

  # stop a container
  def suspend_container (container_id)
    Util.cmd_timeout(60,"docker", "container", "stop", container_id).strip
  end

  # like suspend but forces the container off
  def kill_container(container_id)
    Util.cmd_timeout(60,"docker", "container", "kill", container_id).strip
  end

  # start a container
  def resume_container (container_id)
    Util.cmd("docker", "container", "start", container_id).strip
  end

  # return container information hash
  def inspect_container (container_id)
    JSON.parse(Util.cmd("docker", "container", "inspect", container_id))[0].deep_symbolize_keys
  end

  def get_container_ip (container_id)
    inspect_container(container_id)[:NetworkSettings][:IPAddress]
  end

  def get_container_status (container_id)
    inspect_container(container_id)[:State][:Status]
  end
end