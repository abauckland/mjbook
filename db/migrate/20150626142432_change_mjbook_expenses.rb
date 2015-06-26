class ChangeMjbookExpenses < ActiveRecord::Migration
  def change
    remove_column :mjbook_expenses, :mileage_id
    remove_column :mjbook_expenses, :expend_id

    add_column :mjbook_expenses, :notes, :text

  end
end