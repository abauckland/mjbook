class CreateMjbookWriteoffitems < ActiveRecord::Migration
  def change
    create_table :mjbook_writeoffitems do |t|
      t.integer :writeoff_id
      t.integer :inline_id

      t.timestamps
    end
  end
end
