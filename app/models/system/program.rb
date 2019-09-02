class System::Program < ApplicationRecord

  def self.new_program(name, image_id, icon_path)
    prog = System::Program.create(name: name, image_id: image_id, icon_path: icon_path)
    return prog
  end

end
