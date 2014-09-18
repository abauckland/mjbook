class CreateMjbookInvoicemethods < ActiveRecord::Migration
  def change
    create_table :mjbook_invoicemethods do |t|
      t.string :method

      t.timestamps
    end
  end
end
