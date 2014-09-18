class CreateMjbookCustomers < ActiveRecord::Migration
  def change
    create_table :mjbook_customers do |t|
      t.integer :company_id
      t.string :title
      t.string :first_name
      t.string :surname
      t.string :position
      t.string :address_1
      t.string :address_2
      t.string :city
      t.string :county
      t.string :country
      t.string :postcode
      t.string :phone
      t.string :alt_phone
      t.string :email
      t.string :company
      t.text :notes

      t.timestamps
    end
  end
end
