class System::ProgramResource < ApplicationRecord

  def self.new_program_resource(program_id, resource_id)
    prog_resource = System::ProgramResource.create(program_id: program_id, resource_id: resource_id)
    return prog_resource
  end

  belongs_to :resource, :class_name => 'Resources::Resource', dependent: :destroy
end
