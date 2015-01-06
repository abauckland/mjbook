class CreateMjbookDonations < ActiveRecord::Migration
  def change
    create_table :mjbook_donations do |t|
      t.integer :donor_id
      t.string :participant_id
      t.integer :event_id
      t.timestamp :date
      t.decimal :total

      t.timestamps
    end
  end
end
