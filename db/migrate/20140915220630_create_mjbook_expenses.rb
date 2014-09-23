class CreateMjbookExpenses < ActiveRecord::Migration
  def change
    create_table :mjbook_expenses do |t|
      t.integer :user_id
      t.integer :project_id
      t.integer :supplier_id
      t.integer :hmrcexpcat_id
      t.timestamp :date
      t.timestamp :due_date
      t.decimal :amount, :precision => 8, :scale => 2
      t.decimal :vat, :precision => 8, :scale => 2
      t.string :receipt
      t.integer :recurrence
      t.string :ref
      t.string :supplier_ref
      t.integer :status

      t.timestamps
    end
  end
end
