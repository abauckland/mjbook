class CreateMjbookPeriods < ActiveRecord::Migration
  def change
    create_table :mjbook_periods do |t|
      t.integer :company_id
      t.string :period
      t.timestamp :year_start
      t.decimal :retained

      t.timestamps
    end
  end
end
