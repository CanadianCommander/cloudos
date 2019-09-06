class Api::System::ProgramController < Api::ApiController

  def initialize
    super
    @program_manager_service = ProgramManagerService.instance
    @container_service = ContainerService.instance
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

  # POST /program/:id/start
  def start_program
    begin
      program = @program_manager_service.get_program(params[:id])
      new_container = @container_service.create_container(program)
      render json: success_response(new_container)
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
