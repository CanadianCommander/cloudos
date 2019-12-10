class CreateSecurityRoles < ActiveRecord::Migration[6.0]
  def change
    create_table :roles do |t|
      t.string    :role_name, null: false
      t.timestamps
    end

    create_table :role_security_objects do |t|
      t.integer   :role_id
      t.integer   :security_object_id
      t.timestamps
    end

    create_table :security_objects do |t|
      t.string  :security_object_name, null: false
      t.timestamps
    end

    create_table :user_roles do |t|
      t.integer       :user_id
      t.integer       :role_id
      t.timestamps
    end

    add_foreign_key :user_roles, :roles
    add_foreign_key :user_roles, :users

    add_foreign_key :role_security_objects, :roles
    add_foreign_key :role_security_objects, :security_objects
  end
end
