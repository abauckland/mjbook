class ChangeMjbookCompanyaccounts < ActiveRecord::Migration
  def change
    add_column :mjbook_companyaccounts, :balance, :decimal, :precision => 8, :scale => 2, default: 0.00
    add_column :mjbook_companyaccounts, :date, :timestamp
  end
end