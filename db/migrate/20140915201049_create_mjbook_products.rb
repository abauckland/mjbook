class CreateMjbookProducts < ActiveRecord::Migration
  def change
    create_table :mjbook_products do |t|
      t.integer :company_id
      t.integer :productcategory_id
      t.string :item
      t.decimal :quantity, :precision => 8, :scale => 0
      t.integer :unit_id
      t.decimal :rate, :precision => 8, :scale => 2
      t.integer :vat_id
      t.decimal :vat_due, :precision => 8, :scale => 2
      t.decimal :price, :precision => 8, :scale => 2

      t.timestamps
    end
  end
end
