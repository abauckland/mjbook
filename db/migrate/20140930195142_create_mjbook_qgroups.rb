class CreateMjbookQgroups < ActiveRecord::Migration
  def change
    create_table :mjbook_qgroups do |t|
      t.integer :quote_id
      t.string :ref
      t.string :text
      t.decimal :sub_vat, :precision => 8, :scale => 2
      t.decimal :sub_price, :precision => 8, :scale => 2

      t.timestamps
    end
  end
end
