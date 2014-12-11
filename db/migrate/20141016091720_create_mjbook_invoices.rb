class CreateMjbookInvoices < ActiveRecord::Migration
  def change
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
