require 'singleton'

class Api::System::ResourceService
  include Singleton

  PROGRAM_INSTALL_DIR = '/var/cloudos/install/'.freeze()

  # create new resource of type APPLICATION and link it
  # to the given program_id via program_resources table.
  def create_program_resource(name, program_id)
    ActiveRecord::Base.transaction do
      resource = Resources::Resource.new_resource(PROGRAM_INSTALL_DIR + name, :APPLICATION)
      resource.save!
      Resources::ProgramResource.new_program_resource(program_id, resource.id).save!
      return resource
    end
  end

end
