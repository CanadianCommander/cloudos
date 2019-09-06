class CreateProgramContainer < ActiveRecord::Migration[6.0]
  def change
    create_table :program_containers do |t|
      t.integer :program_id
      t.string  :container_id
      t.integer :status
      t.string  :ip
    end
    add_foreign_key :program_containers, :programs
  end
end
