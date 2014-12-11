class CreateMjbookExpenses < ActiveRecord::Migration
  def change
    create_table :mjbook_expenses do |t|
      t.integer :company_id
      t.integer :user_id
      t.integer :exp_type
      t.integer :project_id
      t.integer :supplier_id
      t.integer :hmrcexpcat_id
      t.integer :mileage_id
      t.timestamp :date
      t.timestamp :due_date
      t.decimal :price, :precision => 8, :scale => 2
      t.decimal :vat, :precision => 8, :scale => 2
      t.decimal :total, :precision => 8, :scale => 2
      t.string :receipt
      t.integer :recurrence
      t.string :ref
      t.string :supplier_ref
      t.string :state

      t.timestamps
    end
  end
end
