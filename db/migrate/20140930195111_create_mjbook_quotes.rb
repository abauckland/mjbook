class CreateMjbookQuotes < ActiveRecord::Migration
  def change
    create_table :mjbook_quotes do |t|
      t.integer :project_id
      t.integer :ref
      t.timestamp :date
      t.integer :status
      t.decimal :total_vat
      t.decimal :total_price

      t.timestamps
    end
  end
end
