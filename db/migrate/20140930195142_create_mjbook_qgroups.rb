class CreateMjbookQgroups < ActiveRecord::Migration
  def change
    create_table :mjbook_qgroups do |t|
      t.integer :quote_id
      t.string :ref
      t.string :text
      t.decimal :sub_vat
      t.decimal :sub_price

      t.timestamps
    end
  end
end
