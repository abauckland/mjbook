class CreateMjbookMiscexpense < ActiveRecord::Migration
  def change
    create_table :mjbook_miscexpense do |t|
      t.integer :company_id
      t.integer :user_id
      t.integer :exp_type
      t.string :ref
      t.integer :project_id
      t.integer :hmrcexpcat_id
      t.timestamp :date
      t.timestamp :due_date
      t.decimal :price
      t.decimal :vat
      t.decimal :total
      t.string :item
      t.integer :provider_id
      t.string :provider_ref
      t.string :receipt
      t.text :note
      t.string :state

      t.timestamps
    end
  end
end
