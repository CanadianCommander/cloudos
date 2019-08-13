class CreatePrograms < ActiveRecord::Migration[6.0]
  def change
    create_table :programs do |t|
      t.string :name
      t.string :image_id
      t.string :icon_path
      t.timestamps
    end
  end
end
