class CreateMjbookMiscexpense < ActiveRecord::Migration
  def change
    create_table :mjbook_miscincomes do |t|
      t.integer :company_id
      t.integer :user_id
      t.string :ref
      t.integer :project_id
      t.integer :hmrcexpcat_id
      t.timestamp :date
      t.timestamp :due_date
      t.decimal :price
      t.decimal :vat
      t.decimal :total
      t.string :reciept
      t.integer :supplier_id
      t.string :supplier_ref
      t.integer :recurrence
      t.text :note
      t.string :state
      
    create_table :mjbook_invoices do |t|
      t.integer :project_id
      t.string :ref
      t.string :customer_ref
      t.decimal :price, :precision => 8, :scale => 2, default: 0.00
      t.decimal :vat_due, :precision => 8, :scale => 2, default: 0.00
      t.decimal :total, :precision => 8, :scale => 2, default: 0.00
      t.string :state
      t.timestamp :date
      t.integer :invoiceterm_id
      t.integer :invoicetype_id


      t.timestamps
    end
  end
end
