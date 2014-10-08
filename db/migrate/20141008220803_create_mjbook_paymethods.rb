class CreateMjbookPaymethods < ActiveRecord::Migration
  def change
    create_table :mjbook_paymethods do |t|
      t.string :method

      t.timestamps
    end
  end
end
