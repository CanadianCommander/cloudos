class System::ContainerProxy < ApplicationRecord
  belongs_to :container, :class_name => 'System::Container'
  belongs_to :proxy, :class_name => 'System::Proxy', dependent: :destroy

  def self.new_container_proxy(container_id, proxy_id)
    System::ContainerProxy.create({container_id: container_id, proxy_id: proxy_id})
  end

end