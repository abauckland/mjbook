class Misccategory < ActiveRecord::Migration
  def change
    create_table :mjbook_misccategories do |t|
      t.integer :company_id
      t.string :name

      t.timestamps
    end
  end
end
