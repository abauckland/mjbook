class CreateMjbookQuotes < ActiveRecord::Migration
  def change
    create_table :mjbook_quotes do |t|
      t.integer :project_id
      t.string :ref
      t.string :title
      t.string :customer_ref
      t.timestamp :date
      t.integer :status
      t.decimal :total_vat, :precision => 8, :scale => 2, default: 0.00
      t.decimal :total_price, :precision => 8, :scale => 2, default: 0.00

      t.timestamps
    end
  end
end
