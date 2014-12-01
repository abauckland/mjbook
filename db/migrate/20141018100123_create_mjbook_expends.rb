class CreateMjbookExpends < ActiveRecord::Migration
  def change
    create_table :mjbook_expends do |t|
      t.integer :exp_type
      t.integer :company_id
      t.integer :user_id
      t.integer :paymethod_id
      t.integer :companyaccount_id
      t.string :expend_receipt
      t.timestamp :date
      t.string :ref
      t.decimal :price, :precision => 8, :scale => 2, default: 0.00
      t.decimal :vat, :precision => 8, :scale => 2, default: 0.00
      t.decimal :total, :precision => 8, :scale => 2, default: 0.00
      t.text :note
      t.string :state
      
      t.timestamps
    end
  end
end
