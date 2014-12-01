class CreateExpenditems < ActiveRecord::Migration
  def change
    create_table :mjbook_expenditems do |t|
      t.integer :expend_id
      t.integer :expense_id
      t.integer :salary_id
      t.integer :transfer_id

      t.timestamps
    end
  end
end
