class CreateApiSession < ActiveRecord::Migration[6.0]
  def change
    create_table :api_sessions do |t|
      t.string :uuid
      t.date :create_date
      t.integer :ttl
      t.integer :user_id
      t.timestamps
    end

    add_foreign_key :api_sessions, :users
    add_index :api_sessions, [:uuid], unique: true
  end
end
