class ChangeMjbookSettings < ActiveRecord::Migration
  def change
    remove_column :mjbook_settings, :yearend
    add_column :mjbook_settings, :year_start, :timestamp
  end
end