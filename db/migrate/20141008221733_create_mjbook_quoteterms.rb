class CreateMjbookQuoteterms < ActiveRecord::Migration
  def change
    create_table :mjbook_quoteterms do |t|
      t.integer :company_id
      t.text :terms

      t.timestamps
    end
  end
end
