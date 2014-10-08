class CreateMjbookQlines < ActiveRecord::Migration
  def change
    create_table :mjbook_qlines do |t|
      t.integer :qgroup_id
      t.string :cat
      t.string :item
      t.decimal :quantity
      t.string :unit
      t.decimal :rate, :precision => 8, :scale => 2
      t.integer :vat_id
      t.decimal :vat, :precision => 8, :scale => 2
      t.decimal :price, :precision => 8, :scale => 2
      t.text :note
      t.integer :linetype
      t.integer :line_order

      t.timestamps
    end
  end
end
