class CreateMjbookSummaries < ActiveRecord::Migration
  def change
    create_table :summaries do |t|
      t.integer :company_id
      t.integer :account_id
      t.integer :payment_id
      t.integer :expend_id
      t.decimal :amount_in, :precision => 8, :scale => 2, default: 0.00
      t.decimal :amount_out, :precision => 8, :scale => 2, default: 0.00
      t.decimal :balance, :precision => 8, :scale => 2, default: 0.00
      t.decimal :account_balance, :precision => 8, :scale => 2, default: 0.00
      t.timestamp :date

      t.timestamps
    end
  end
end
