class Api::System::ContainerController < Api::ApiController

  def initialize
    super

    @container_service = System::ContainerService.instance
  end

  # GET containers/list
  def list_containers
    status = params[:status].nil? ? -1 : params[:status].to_sym
    if status == -1 || System::Container.statuses.include?(status)
      render json: success_response(@container_service.all_containers(status))
    else
      render json: error_response("Invalid status code [#{params[:status]}]"), status: 400
    end
  end

  # GET container/:id/
  def get_container
    begin
      render json: success_response(@container_service.get_container(params[:id]))
    rescue ActiveRecord::RecordNotFound => e
      render json: error_response("no container with id [#{params[:id]}] found"), status: 400
    end
  end

  # PUT container/:id/suspend
  def suspend_container
    begin
      con = @container_service.get_container(params[:id])
      @container_service.suspend_container(con)
      render json: success_response(con)
    rescue ActiveRecord::RecordNotFound => e
      render json: error_response("no container with id [#{params[:id]}] found"), status: 400
    end
  end

  # PUT container/:id/resume
  def resume_container
    begin
      con = @container_service.get_container(params[:id])
      @container_service.resume_container(con)
      render json: success_response(con)
    rescue ActiveRecord::RecordNotFound => e
      render json: error_response("no container with id [#{params[:id]}] found"), status: 400
    end
  end

  # DELETE container/:id/destroy
  def destroy_container
    begin
      @container_service.destroy_container(params[:id])
      render json: success_response({})
    rescue ActiveRecord::RecordNotFound => e
      render json: error_response("no container with id [#{params[:id]}] found"), status: 400
    end
  end

end