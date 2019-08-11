class Api::System::ProgramController < Api::ApiController

  def listPrograms
    res = success_response(ProgramManagerService.instance.getInstallPrograms)
    render json: res
  end

  def getProgramInfo
    begin
      program = ProgramManagerService.instance.getProgram(params[:id])
      render json: success_response(program)
    rescue ActiveRecord::RecordNotFound => e
      render json: error_response("Program #{params[:id]} not found")
    end
  end


end
