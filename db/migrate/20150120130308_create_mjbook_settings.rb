class CreateMjbookSettings < ActiveRecord::Migration
  def change
    create_table :mjbook_settings do |t|
      t.integer :company_id
      t.string :email_domain
      t.string :email_username
      t.string :email_password
      t.timestamp :yearend

      t.timestamps
    end
  end
end
