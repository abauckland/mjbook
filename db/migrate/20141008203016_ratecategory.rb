class Ratecategory < ActiveRecord::Migration
  def change
    create_table :mjbook_ratecategories do |t|
      t.integer :company_id
      t.string :name

      t.timestamps
    end
  end
end
