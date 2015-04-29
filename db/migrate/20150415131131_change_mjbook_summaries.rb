class ChangeMjbookSummaries < ActiveRecord::Migration
  def change
    add_column :mjbook_summaries, :transfer_id, :integer
    add_column :mjbook_summaries, :state, :string
  end
end