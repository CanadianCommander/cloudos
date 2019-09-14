class System::Program < ApplicationRecord
  has_many :program_containers, :class_name => 'System::ProgramContainer', foreign_key: "program_id", dependent: :destroy
  has_many :program_resources, :class_name => 'System::ProgramResource', foreign_key: "program_id", dependent: :destroy

  def self.new_program(name, image_id, icon_path)
    prog = System::Program.create(name: name, image_id: image_id, icon_path: icon_path)
    return prog
  end

  before_destroy do |program|
    begin
      Docker::DockerService.instance.delete_image(program.image_id)
    rescue RuntimeError, Timeout::Error => e
      # log and continue with delete even if there is an error
      Rails.logger.error("Failed to delete docker image with error: #{e.to_s}\n#{e.backtrace.join("\n")}")
    end
  end

end
