class CreateMjbookDonors < ActiveRecord::Migration
  def change
    create_table :mjbook_donors do |t|
      t.string :title
      t.string :first_name
      t.string :surname
      t.string :house
      t.string :postcode

      t.timestamps
    end
  end
end
