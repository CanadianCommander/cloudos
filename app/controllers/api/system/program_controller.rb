class Api::System::ProgramController < Api::ApiController

  def list_programs
    res = success_response(ProgramManagerService.instance.get_installed_programs)
    render json: res
  end

  def get_program_info
    begin
      program = ProgramManagerService.instance.get_program(params[:id])
      render json: success_response(program)
    rescue ActiveRecord::RecordNotFound => e
      render json: error_response("Program #{params[:id]} not found"), status: 400
    end
  end

end
