class CreateMjbookIncomes < ActiveRecord::Migration
  def change
    create_table :mjbook_miscincomes do |t|
      t.integer :company_id
      t.string :ref
      t.integer :project_id
      t.timestamp :date
      t.decimal :price
      t.decimal :vat
      t.decimal :total
      t.integer :customer_id
      t.string :customer_ref
      t.integer :recurrence
      t.text :note
      t.string :state

      t.timestamps
    end
  end
end
