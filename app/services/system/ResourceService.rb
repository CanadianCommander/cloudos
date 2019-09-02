require 'singleton'

class System::ResourceService
  include Singleton

  PROGRAM_INSTALL_DIR = '/var/cloudos/install/'.freeze

  # create new resource of type APPLICATION and link it
  # to the given program_id via program_resources table.
  def create_program_resource(name, program_id)
    Resources::ResourceProgram.new_resource_program(program_id, PROGRAM_INSTALL_DIR + name)
  end

end
