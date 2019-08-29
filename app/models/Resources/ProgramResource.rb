class Resources::ProgramResource < ApplicationRecord

  def self.new_program_resource(program_id, resource_id)
    prog_resource = Resources::ProgramResource.new
    prog_resource.program_id = program_id
    prog_resource.resource_id = resource_id
    return prog_resource
  end
end
