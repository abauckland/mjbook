class CreateMjbookQlines < ActiveRecord::Migration
  def change
    create_table :mjbook_qlines do |t|
      t.integer :qgroup_id
      t.string :cat, default: "Select category"
      t.string :item, default: "Select item"
      t.decimal :quantity, :precision => 8, :scale => 0, default: 0
      t.integer :unit_id, default: 1
      t.decimal :rate, :precision => 8, :scale => 2, default: 0.00
      t.integer :vat_id, default: 1
      t.decimal :vat_due, :precision => 8, :scale => 2, default: 0.00
      t.decimal :price, :precision => 8, :scale => 2, default: 0.00
      t.text :note
      t.integer :linetype, default: 1
      t.integer :line_order, default: 1

      t.timestamps
    end
  end
end
