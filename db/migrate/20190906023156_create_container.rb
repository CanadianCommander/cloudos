class CreateContainer < ActiveRecord::Migration[6.0]
  def change
    create_table :program_containers do |t|
      t.integer :program_id
      t.integer :container_id
      t.timestamps
    end

    create_table :containers do |t|
      t.string  :container_id
      t.integer :status
      t.string  :ip
      t.timestamps
    end

    add_foreign_key :program_containers, :programs
    add_foreign_key :program_containers, :containers
  end
end
