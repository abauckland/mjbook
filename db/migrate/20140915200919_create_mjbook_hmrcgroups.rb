class CreateMjbookHmrcgroups < ActiveRecord::Migration
  def change
    create_table :mjbook_hmrcgroups do |t|
      t.string :group

      t.timestamps
    end
  end
end
