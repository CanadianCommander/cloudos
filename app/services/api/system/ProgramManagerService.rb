require 'singleton'

class Api::System::ProgramManagerService
  include Singleton

  # return a list of install programs
  def getInstallPrograms
    return Program.all
  end

  def getProgram (id)
    return Program.find(id)
  end


end
