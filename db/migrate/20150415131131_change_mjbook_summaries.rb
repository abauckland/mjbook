class ChangeMjbookSummaries < ActiveRecord::Migration
  def change
    add_column :mjbook_summaries, :transfer_id, :integer
  end
end