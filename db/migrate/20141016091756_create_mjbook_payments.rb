class CreateMjbookPayments < ActiveRecord::Migration
  def change
    create_table :mjbook_payments do |t|
      t.string :ref
      t.integer :company_id
      t.integer :user_id
      t.integer :paymethod_id
      t.integer :companyaccount_id
      t.decimal :price, :precision => 8, :scale => 2, default: 0.00
      t.decimal :vat, :precision => 8, :scale => 2, default: 0.00
      t.decimal :total, :precision => 8, :scale => 2, default: 0.00
      t.timestamp :date
      t.integer :inc_type
      t.text :notes
      t.string :state
      
      t.timestamps
    end
  end
end
