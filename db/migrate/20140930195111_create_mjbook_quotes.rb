class CreateMjbookQuotes < ActiveRecord::Migration
  def change
    create_table :mjbook_quotes do |t|
      t.integer :project_id
      t.integer :ref
      t.timestamp :date
      t.integer :status
      t.decimal :total_vat, :precision => 8, :scale => 2
      t.decimal :total_price, :precision => 8, :scale => 2

      t.timestamps
    end
  end
end
