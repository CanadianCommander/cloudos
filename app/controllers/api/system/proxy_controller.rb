class Api::System::ProxyController < Api::ApiController

  def initialize
    super
    @proxy_service = System::ProxyService.instance
  end

  # GET /proxies/list
  def list_proxies
    render json: success_response(@proxy_service.all_proxies)
  end

  # POST /proxy
  # create a new proxy
  def create_proxy
    params.require(:int_port)
    params.require(:ip)
    params.require(:proto)
    params.require(:type)
    params.permit(:proto, array: [:http, :https])
    params.permit(:type, array: [:static, :transient])
    if params[:ttl].nil?
      params[:ttl] =  System::ProxyService::DEFAULT_TTL
    end
    render json: success_response(@proxy_service.create_proxy(params[:int_port], params[:ip], params[:proto], params[:type], params[:ttl]))
  end

  # POST /proxy/container
  # create a new container proxy
  def create_container_proxy
    begin
      params.require(:container_id)
      params.require(:int_port)
      params.require(:proto)
      params.require(:type)
      params.permit(:proto, array: [:http, :https])
      params.permit(:type, array: [:transient, :static])
      if params[:ttl].nil?
        params[:ttl] = System::ProxyService::DEFAULT_TTL
      end
      render json: success_response(@proxy_service.create_container_proxy(params[:container_id], params[:int_port], params[:proto], params[:type], params[:ttl]))
    rescue ActiveRecord::RecordNotFound => e
      render json: error_response("Container id invalid, [#{params[:container_id]}].")
    end
  end

  # GET /proxy/:id
  # get proxy information
  def get_proxy
    begin
      proxy = @proxy_service.get_proxy(params[:id])
      render json: success_response(proxy)
    rescue ActiveRecord::RecordNotFound => e
      render json: error_response("Proxy [#{params[:id]}] not found"), status: 400
    end
  end

  # DELETE /proxy/:id
  def destroy_proxy
    begin
      @proxy_service.destroy_proxy(params[:id])
      render json: success_response({})
    rescue ActiveRecord::RecordNotFound => e
      render json: error_response("Proxy [#{params[:id]}] not found")
    end
  end

  # PUT /proxy/:id
  def update_proxy
    params.permit(:type, array: [:transient, :static])
    begin
      render json: success_response(@proxy_service.update_proxy(params[:id], params[:int_port], params[:ip], params[:proto], params[:type], params[:ttl]))
    rescue ActiveRecord::RecordNotFound => e
      render json: error_response("Proxy [#{params[:id]}] not found")
    end
  end

end