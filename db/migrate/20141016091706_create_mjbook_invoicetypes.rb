class CreateMjbookInvoicetypes < ActiveRecord::Migration
  def change
    create_table :mjbook_invoicetypes do |t|
      t.string :text

      t.timestamps
    end
  end
end
