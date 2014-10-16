class CreateMjbookIngroups < ActiveRecord::Migration
  def change
    create_table :mjbook_ingroups do |t|
      t.integer :invoice_id
      t.string :ref
      t.string :text
      t.decimal :price, :precision => 8, :scale => 2, default: 0.00
      t.decimal :vat_due, :precision => 8, :scale => 2, default: 0.00
      t.decimal :total, :precision => 8, :scale => 2, default: 0.00
      t.integer :group_order, default: 1

      t.timestamps
    end
  end
end
