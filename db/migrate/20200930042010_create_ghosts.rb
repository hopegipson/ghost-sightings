class CreateGhosts < ActiveRecord::Migration
  def change
    create_table :ghosts do |t|
      t.string :name
      t.string :content
      t.string :creator_id

      t.timestamps null: false
    end
  end
end
