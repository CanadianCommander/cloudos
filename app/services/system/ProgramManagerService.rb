require 'singleton'

class System::ProgramManagerService
  include Singleton

  # return a list of install programs
  def get_installed_programs
    return System::Program.all
  end

  def get_program (id)
    return System::Program.find(id)
  end

  def install_from_git(git_url)
    ActiveRecord::Base.transaction do
      app_name = git_url.split('/')[-1].chomp('.git')

      # create program record
      new_program = System::Program.new_program(app_name, nil, nil)
      new_program.save!

      # reserve program resource
      System::ResourceService.instance.create_program_resource(app_name, new_program.id)
    end
  end
end
