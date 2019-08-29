class ProgramResources < ActiveRecord::Migration[6.0]
  def change
    create_table :program_resources do |t|
      t.integer :program_id
      t.integer :resource_id
    end
    add_foreign_key :program_resources, :programs
    add_foreign_key :program_resources, :resources
  end
end
