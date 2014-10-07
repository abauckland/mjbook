class CreateMjbookVats < ActiveRecord::Migration
  def change
    create_table :mjbook_vats do |t|
      t.string :cat
      t.decimal :rate

      t.timestamps
    end
  end
end
