class CreateMjbookCreditnoteitems < ActiveRecord::Migration
  def change
    create_table :mjbook_creditnoteitems do |t|
      t.integer :creditnote_id
      t.integer :inline_id

      t.timestamps
    end
  end
end
