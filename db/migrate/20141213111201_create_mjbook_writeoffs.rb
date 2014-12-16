class CreateMjbookWriteoffs < ActiveRecord::Migration
  def change
    create_table :mjbook_writeoffs do |t|
      t.integer :company_id
      t.string :ref
      t.decimal :price
      t.dedimal :vat
      t.decimal :total
      t.timestamp :date
      t.text :notes

      t.timestamps
    end
  end
end
