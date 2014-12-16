class CreateMjbookCreditnotes < ActiveRecord::Migration
  def change
    create_table :mjbook_creditnotes do |t|
      t.integer :company_id
      t.string :ref
      t.decimal :price
      t.decimal :vat
      t.decimal :total
      t.timestamp :date
      t.text :notes
      t.string :state

      t.timestamps
    end
  end
end
