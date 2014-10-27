class CreateMjbookTransfers < ActiveRecord::Migration
  def change
    create_table :mjbook_transfers do |t|
      t.integer :company_id
      t.integer :user_id
      t.ingeter :account_from_id
      t.integer :account_to_id
      t.string :total
      t.timestamp :date
      t.string :status

      t.timestamps
    end
  end
end
