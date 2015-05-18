class CreateMjbookJournals < ActiveRecord::Migration
  def change
    create_table :mjbook_journals do |t|
      t.integer :company_id
      t.integer :paymentitem_id
      t.integer :expenditem_id
      t.decimal :adjustment, :precision => 8, :scale => 2, default: 0.00
      t.integer :period_id
      t.text :note

      t.timestamps
    end
  end
end
