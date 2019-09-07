class Api::System::ProgramController < Api::ApiController

  def initialize
    super
    @program_manager_service = ProgramManagerService.instance
    @container_service = ContainerService.instance
    @docker_service = Docker::DockerService.instance
  end

  # GET /programs/list
  def list_programs
    render json: success_response(@program_manager_service.get_installed_programs)
  end

  # GET /program/:id
  def get_program_info
    begin
      program = @program_manager_service.get_program(params[:id])
      render json: success_response(program)
    rescue ActiveRecord::RecordNotFound => e
      render json: error_response("Program #{params[:id]} not found"), status: 400
    end
  end

  # GET /program/:id/containers
  # get a list of all containers associated with this program
  def get_containers
    begin
      out = []
      @program_manager_service.get_program(params[:id]).program_containers.each do |prog_c|
        out << prog_c.container
      end
      render json: success_response(out)
    rescue ActiveRecord::RecordNotFound => e
      render json: error_response("Program #{params[:id]} not found"), status: 400
    end
  end

  # POST /program/:id/start
  # start a program. i.e. create a new container from the image of this program
  # and return the new container
  def start_program
    begin
      program = @program_manager_service.get_program(params[:id])
      new_container = @container_service.create_container(program)
      render json: success_response(new_container)
    rescue ActiveRecord::RecordNotFound => e
      render json: error_response("Program #{params[:id]} not found"), status: 400
    end
  end

  # POST /program/:id/stop
  # stops all running containers for this program. It is more likely that
  # one would wish to stop a particular container instead.
  def stop_program
    begin
      program = @program_manager_service.get_program(params[:id])
      program.program_containers.each do |container_ref|
        container_ref.destroy
      end
      render json: success_response({})
    rescue ActiveRecord::RecordNotFound => e
      render json: error_response("Program #{params[:id]} not found"), status: 400
    end
  end

  # POST /program/install/git
  def install_program_from_git
    if params[:git_url] != nil
      render json: success_response(@program_manager_service.install_from_git(params[:git_url]))
    else
      render json: error_response("Required parameter git_url not provided"), status: 400
    end
  end
end
