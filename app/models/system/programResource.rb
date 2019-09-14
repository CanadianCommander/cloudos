class System::ProgramResource < ApplicationRecord
  belongs_to :resource, :class_name => 'Resources::Resource', dependent: :destroy
  belongs_to :program, :class_name => 'System::Program'

  def self.new_program_resource(program_id, resource_id)
    prog_resource = System::ProgramResource.create!(program_id: program_id, resource_id: resource_id)
    return prog_resource
  end

end
