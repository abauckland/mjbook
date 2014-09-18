class CreateMjbookMileages < ActiveRecord::Migration
  def change
    create_table :mjbook_mileages do |t|
      t.integer :job_id
      t.integer :mileagemode_id
      t.integer :user_id
      t.integer :hmrcexpcat_id
      t.string :start
      t.string :finish
      t.integer :return
      t.decimal :distance, :precision => 4, :scale => 0
      t.timestamp :date

      t.timestamps
    end
  end
end
