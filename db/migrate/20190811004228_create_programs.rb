class CreatePrograms < ActiveRecord::Migration[6.0]
  def change
    create_table :programs do |t|
      t.string :name
      t.string :container_id
      t.string :image_id
      t.string :icon_path
      t.integer :memory_requirement

      t.timestamps
    end
  end
end
