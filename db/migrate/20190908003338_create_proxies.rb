class CreateProxies < ActiveRecord::Migration[6.0]
  def change
    create_table :proxies do |t|
      t.integer :external_port
      t.integer :internal_port
      t.string  :internal_ip
      t.integer :proto
      t.integer :proxy_type
      t.integer :ttl_sec
      t.timestamps
    end

    create_table :container_proxies do |t|
      t.integer :container_id
      t.integer :proxy_id
      t.timestamps
    end

    add_foreign_key :container_proxies, :containers
    add_foreign_key :container_proxies, :proxies
    add_index :proxies, [:external_port], :unique => true
  end
end
