class System::ProgramContainer < ApplicationRecord
  belongs_to :program, :class_name => 'System::Program'
  belongs_to :container, :class_name => 'System::Container', dependent: :destroy

  def self.new_program_container(program_id, container_id)
    prog_cont = System::ProgramContainer.create(program_id: program_id, container_id: container_id)
    return prog_cont
  end

end
