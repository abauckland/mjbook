class CreateMjbookQlines < ActiveRecord::Migration
  def change
    create_table :mjbook_qlines do |t|
      t.integer :qgroup_id
      t.string :cat
      t.string :item
      t.decimal :quantity
      t.string :unit
      t.decimal :rate
      t.integer :vat_id
      t.decimal :vat
      t.decimal :price
      t.text :note
      t.integer :linetype
      t.integer :line_order

      t.timestamps
    end
  end
end
