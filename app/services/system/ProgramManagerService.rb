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

  # create a new program by installing it from the specified git repo.
  # returns the newly created program object.
  def install_from_git(git_url)
    ActiveRecord::Base.transaction do
      app_name = git_url.split('/')[-1].chomp('.git')

      # create program record
      new_program = System::Program.new_program(app_name, nil, nil)

      # reserve program resource
      prog_resource = System::ResourceService.instance.create_program_resource(app_name, new_program.id)
      Fs::FileService.instance.insure_path_empty(prog_resource)

      System::InstallationService.instance.git_install(new_program, prog_resource, git_url)

      return new_program
    end
  end

  # Delete a program and all its associated database / filesystem objects.
  # this includes things like docker containers and disk resources.
  def delete_program(id)
    System::Program.find(id).destroy!
  end

end

