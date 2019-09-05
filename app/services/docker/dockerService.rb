require 'singleton'

class Docker::DockerService
  include Singleton

  # builds a new docker image from the specified directory and return new image id
  def build_image_from_docker_file (docker_path)
    docker_image_id = Util.cmd("docker", "build", docker_path, "--force-rm=true", "--quiet").match(/:([\d\w]*)/)
    unless docker_image_id.nil? || docker_image_id.size < 2
      return docker_image_id[1]
    end

    raise RuntimeError.new("Could not retrieve docker image id")
  end

  def get_all_image_ids
    ids = Util.cmd("docker", "images", "--all", "--quiet").split("\n")
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
end