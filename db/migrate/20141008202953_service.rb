class Service < ActiveRecord::Migration
  def change
    create_table :mjbook_services do |t|
      t.integer :company_id
      t.integer :servicecategory_id
      t.string :item
      t.decimal :quantity, :precision => 8, :scale => 0
      t.integer :unit_id
      t.decimal :cost, :precision => 8, :scale => 2
      t.integer :vat_id
      t.decimal :vat, :precision => 3, :scale => 0
      t.decimal :price, :precision => 8, :scale => 2

      t.timestamps
    end  
  end
end
