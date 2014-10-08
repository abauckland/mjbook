class CreateMjbookCompanyaccounts < ActiveRecord::Migration
  def change
    create_table :mjbook_companyaccounts do |t|
      t.integer :company_id
      t.string :name

      t.timestamps
    end
  end
end
