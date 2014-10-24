class CreateMjbookCompanyaccounts < ActiveRecord::Migration
  def change
    create_table :mjbook_companyaccounts do |t|
      t.integer :company_id
      t.string :name
      t.string :provider
      t.string :code
      t.string :number

      t.timestamps
    end
  end
end
