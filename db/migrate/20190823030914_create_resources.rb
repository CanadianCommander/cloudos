class CreateResources < ActiveRecord::Migration[6.0]
  def change
    create_table :resources do |t|
      t.string :path
      t.integer :type
      t.timestamps
    end
    add_index :resources, [:path], :unique => true
  end
end
