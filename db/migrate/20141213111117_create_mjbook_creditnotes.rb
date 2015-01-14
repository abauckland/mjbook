class CreateMjbookCreditnotes < ActiveRecord::Migration
  def change
    create_table :mjbook_creditnotes do |t|
      t.integer :company_id
      t.string :ref
      t.decimal :price, :precision => 8, :scale => 2, default: 0.00
      t.decimal :vat, :precision => 8, :scale => 2, default: 0.00
      t.decimal :total, :precision => 8, :scale => 2, default: 0.00
      t.timestamp :date
      t.text :notes
      t.string :state

      t.timestamps
    end
  end
end
