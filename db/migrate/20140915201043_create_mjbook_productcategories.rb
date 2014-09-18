class CreateMjbookProductcategories < ActiveRecord::Migration
  def change
    create_table :mjbook_productcategories do |t|
      t.integer :company_id
      t.string :name

      t.timestamps
    end
  end
end
