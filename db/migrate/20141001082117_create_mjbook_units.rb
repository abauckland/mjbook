class CreateMjbookUnits < ActiveRecord::Migration
  def change
    create_table :mjbook_units do |t|
      t.text :text

      t.timestamps
    end
  end
end
