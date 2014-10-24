class CreateMjbookSalaries < ActiveRecord::Migration
  def change
    create_table :mjbook_salaries do |t|
      t.integer :company_id
      t.integer :user_id
      t.decimal :total, :precision => 8, :scale => 2, default: 0.00
      t.timestamp :date

      t.timestamps
    end
  end
end
