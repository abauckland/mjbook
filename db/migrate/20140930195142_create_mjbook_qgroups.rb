class CreateMjbookQgroups < ActiveRecord::Migration
  def change
    create_table :mjbook_qgroups do |t|
      t.integer :quote_id
      t.integer :ref, default: 1
      t.integer :group_order, default: 1
      t.string :text, default: "Please add brief description of work"
      t.decimal :sub_vat, :precision => 8, :scale => 2, default: 0.00
      t.decimal :sub_price, :precision => 8, :scale => 2, default: 0.00

      
      t.timestamps
    end
  end
end
