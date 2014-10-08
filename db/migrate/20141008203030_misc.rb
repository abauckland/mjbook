class Misc < ActiveRecord::Migration
  def change
    create_table :mjbook_miscs do |t|
      t.integer :misccategory_id
      t.string :item


      t.timestamps
    end 
  end
end
