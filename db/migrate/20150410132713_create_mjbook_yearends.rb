class CreateMjbookYearends < ActiveRecord::Migration
  def change
    create_table :mjbook_yearends do |t|
      t.integer :company_id
      t.timestamp :year_start
      t.decimal :amount

      t.timestamps
    end
  end
end
