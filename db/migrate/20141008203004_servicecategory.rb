class Servicecategory < ActiveRecord::Migration
  def change
    create_table :mjbook_servicecategories do |t|
      t.integer :company_id
      t.string :name

      t.timestamps
    end
  end
end
