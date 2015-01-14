class CreateMjbookWriteoffs < ActiveRecord::Migration
  def change
    create_table :mjbook_writeoffs do |t|
      t.integer :company_id
      t.string :ref
      t.decimal :price, :precision => 8, :scale => 2, default: 0.00
      t.decimal :vat, :precision => 8, :scale => 2, default: 0.00
      t.decimal :total, :precision => 8, :scale => 2, default: 0.00
      t.timestamp :date
      t.text :notes

      t.timestamps
    end
  end
end
