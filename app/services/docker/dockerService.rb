require 'singleton'

class Docker::DockerService
  include Singleton

  # builds a new docker image from the specified directory
  def build_image_from_docker_file (docker_path)
    Util.cmd("docker build #{docker_path} --force-rm --quiet")
  end

  def get_all_image_ids
    Util.cmd("docker images --all --quiet").split("/n")
  end

  def delete_image(image_id)
    Util.cmd("docker image rm #{image_id}")
  end

  def delete_orphan_images
    image_ids = get_all_image_ids
    System::Program.all.each do |program|
      image_ids.delete(program.image_id)
    end

    # any images left in image_ids are orphans
    image_ids.each do |image|
      delete_image(image)
    end
  end
end