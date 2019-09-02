class Api::System::ProgramController < Api::ApiController

  # GET /programs/list
  def list_programs
    render json: success_response(ProgramManagerService.instance.get_installed_programs)
  end

  # GET /program/:id
  def get_program_info
    begin
      program = ProgramManagerService.instance.get_program(params[:id])
      render json: success_response(program)
    rescue ActiveRecord::RecordNotFound => e
      render json: error_response("Program #{params[:id]} not found"), status: 400
    end
  end

  # POST /program/install/git
  def install_program_from_git
    if params[:git_url] != nil
      render json: success_response(ProgramManagerService.instance.install_from_git(params[:git_url]))
    else
      render json: error_response("Required parameter git_url not provided"), status: 400
    end
  end
end
