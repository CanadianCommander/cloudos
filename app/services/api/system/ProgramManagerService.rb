require 'singleton'

class Api::System::ProgramManagerService
  include Singleton

  # return a list of install programs
  def getInstallPrograms
    return System::Program.all
  end

  def getProgram (id)
    return System::Program.find(id)
  end


end
