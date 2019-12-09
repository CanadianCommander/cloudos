require 'singleton'

class System::ProxyService
  include Singleton

  DEFAULT_TTL = 60*60 # 1 hour

  # get a list of all proxies
  def all_proxies
    System::Proxy.all
  end

  # get a proxy record by id
  def get_proxy(id)
    System::Proxy.find(id)
  end

  # get a proxy record by external port number
  def get_proxy_by_external_port(port)
    proxy = System::Proxy.where(external_port: port)
    unless proxy.nil?
      # there can only ever be one proxy per port (enforced by unique key)
      return proxy[0]
    end
    return nil
  end

  # create a new proxy record
  def create_proxy(int_port, int_ip, proto, type, ttl=DEFAULT_TTL)
    System::Proxy.new_proxy(next_available_port, int_port, int_ip, proto, type, ttl)
  end

  # create a new proxy record, and link it to a container via a ContainerProxy record
  def create_container_proxy(container_id, int_port, proto, type, ttl=DEFAULT_TTL)
    container_ip = System::ContainerService.instance.get_container(container_id).ip
    System::Proxy.new_container_proxy(container_id, next_available_port, int_port, container_ip, proto, type, ttl)
  end

  # destroy the proxy record with the given id
  def destroy_proxy(id)
    System::Proxy.find(id).destroy
  end

  # destroy any proxies who's last update date is older then their ttl
  def destroy_expired_proxies
    System::Proxy.all.each do |proxy|
      if proxy.expired?
        proxy.destroy
      end
    end
  end

  # get the next available external port number
  def next_available_port
    destroy_expired_proxies

    (Rails.application.config.settings[:proxy][:app_port_start]...Rails.application.config.settings[:proxy][:app_port_end]).each do |i|
      proxy = nil
      begin
        proxy = get_proxy_by_external_port(i)
      rescue ActiveRecord::RecordNotFound => e
        #suppress
      end

      if proxy.nil?
        return i
      end
    end

    raise RuntimeError.new("All ports in use")
  end

  # update a proxy record
  def update_proxy(proxy_id, internal_port, internal_ip, proto, type, ttl=nil)
    update_hash = {}

    unless internal_port.nil?
      update_hash[:internal_port] = internal_port
    end
    unless internal_ip.nil?
      update_hash[:internal_ip] = internal_ip
    end
    unless proto.nil?
      update_hash[:proto] = proto
    end
    unless type.nil?
      update_hash[:proxy_type] = type
    end
    unless ttl.nil?
      update_hash[:ttl_sec] = ttl
    end

    proxy = System::Proxy.find(proxy_id)
    proxy.update!(update_hash)
    proxy
  end

end