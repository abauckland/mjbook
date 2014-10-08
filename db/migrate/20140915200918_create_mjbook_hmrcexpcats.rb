class CreateMjbookHmrcexpcats < ActiveRecord::Migration
  def change
    create_table :mjbook_hmrcexpcats do |t|
      t.integer :company_id
      t.string :category
      t.string :group

      t.timestamps
    end
  end
end
