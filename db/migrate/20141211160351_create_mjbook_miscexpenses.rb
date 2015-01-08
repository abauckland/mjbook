class CreateMjbookMiscexpenses < ActiveRecord::Migration
  def change
    create_table :mjbook_miscexpenses do |t|
      t.integer :company_id
      t.integer :user_id
      t.string :ref
      t.integer :project_id
      t.integer :hmrcexpcat_id
      t.timestamp :date
      t.timestamp :due_date
      t.decimal :price, :precision => 8, :scale => 2, default: 0.00
      t.decimal :vat, :precision => 8, :scale => 2, default: 0.00
      t.decimal :total, :precision => 8, :scale => 2, default: 0.00
      t.string :reciept
      t.integer :supplier_id
      t.string :supplier_ref
      t.integer :recurrence
      t.text :note
      t.string :state

      t.timestamps
    end
  end
end
