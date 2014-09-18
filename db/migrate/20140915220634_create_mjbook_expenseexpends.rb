class CreateMjbookExpenseexpends < ActiveRecord::Migration
  def change
    create_table :mjbook_expenseexpends do |t|
      t.string :expense_id
      t.string :expenditure_id

      t.timestamps
    end
  end
end
