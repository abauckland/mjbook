class CreateMjbookDonations < ActiveRecord::Migration
  def change
    create_table :mjbook_donations do |t|
      t.integer :donor_id
      t.integer :participant_id
      t.integer :event_id
      t.timestamp :date
      t.decimal :total, :precision => 8, :scale => 2, default: 0.00

      t.timestamps
    end
  end
end
