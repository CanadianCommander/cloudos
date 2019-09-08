class System::Proxy < ApplicationRecord
  # static ignores ttl. transient does not
  enum proxy_type: [:static, :transient]
  enum proto: [:http, :https]
  has_one :container_proxy, :class_name => 'System::ContainerProxy', foreign_key: "proxy_id", dependent: :destroy

  def self.new_proxy(ext_port, int_port, ip, proto, type = :transient, ttl=System::ProxyService::DEFAULT_TTL)
    System::Proxy.create({external_port: ext_port, internal_port: int_port, internal_ip: ip, proto: proto, proxy_type: type, ttl_sec: ttl})
  end

  def self.new_container_proxy(container_id, ext_port, int_port, ip, proto, type = :transient, ttl=System::ProxyService::DEFAULT_TTL)
    transaction do
      proxy = new_proxy(ext_port, int_port, ip, proto, type, ttl)
      System::ContainerProxy.new_container_proxy(container_id, proxy.id)
      return proxy
    end
  end

  def expired?
    transient? && (Time.now.sec - updated_at.sec > ttl_sec)
  end
end