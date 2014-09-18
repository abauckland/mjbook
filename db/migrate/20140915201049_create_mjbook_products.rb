class CreateMjbookProducts < ActiveRecord::Migration
  def change
    create_table :mjbook_products do |t|
      t.integer :company_id
      t.integer :productcategory_id
      t.string :item
      t.decimal :quantity, :precision => 8, :scale => 0
      t.integer :unit_id
      t.decimal :cost, :precision => 8, :scale => 2
      t.decimal :vat, :precision => 3, :scale => 0
      t.decimal :price, :precision => 8, :scale => 2

      t.timestamps
    end
  end
end
