class CreateMjbookPaymethods < ActiveRecord::Migration
  def change
    create_table :mjbook_paymethods do |t|
      t.string :text

      t.timestamps
    end
  end
end
