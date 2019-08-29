class System::Program < ApplicationRecord

  def self.new_program(name, image_id, icon_path)
    prog = System::Program.new()
    prog.name = name
    prog.image_id = image_id
    prog.icon_path = icon_path
    return prog
  end
end
