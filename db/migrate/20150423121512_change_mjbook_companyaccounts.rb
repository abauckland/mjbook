class ChangeMjbookCompanyaccounts < ActiveRecord::Migration
  def change
    add_column :mjbook_companyaccounts, :date, :timestamp
  end
end