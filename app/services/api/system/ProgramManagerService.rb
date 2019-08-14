require 'singleton'

class Api::System::ProgramManagerService
  include Singleton

  # return a list of install programs
  def get_installed_programs
    return System::Program.all
  end

  def get_program (id)
    return System::Program.find(id)
  end
end
