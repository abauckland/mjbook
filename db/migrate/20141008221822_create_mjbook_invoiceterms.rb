class CreateMjbookInvoiceterms < ActiveRecord::Migration
  def change
    create_table :mjbook_invoiceterms do |t|
      t.integer :company_id
      t.integer :period
      t.text :terms

      t.timestamps
    end
  end
end
