class CreateMjbookPayments < ActiveRecord::Migration
  def change
    create_table :mjbook_payments do |t|
      t.integer :user_id
      t.integer :invoice_id
      t.integer :paymethod_id
      t.integer :companyaccount_id
      t.decimal :price, :precision => 8, :scale => 2, default: 0.00
      t.decimal :vat_due, :precision => 8, :scale => 2, default: 0.00
      t.decimal :total, :precision => 8, :scale => 2, default: 0.00
      t.datestamp :date
      t.text :note

      t.timestamps
    end
  end
end
