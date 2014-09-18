class CreateMjbookExpenditures < ActiveRecord::Migration
  def change
    create_table :mjbook_expenditures do |t|
      t.decimal :amount_paid, :precision => 8, :scale => 2
      t.timestamp :date
      t.string :ref
      t.string :method
      t.integer :user_id
      t.string :expend_receipt

      t.timestamps
    end
  end
end
