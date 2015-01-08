class CreateMjbookPaymentitems < ActiveRecord::Migration
  def change
    create_table :mjbook_paymentitems do |t|
      t.integer :payment_id
      t.integer :inline_id
      t.integer :donation_id
      t.integer :miscincome_id
      t.integer :transfer_id
      t.timestamps
    end
  end
end
