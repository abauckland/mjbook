module Mjbook
  class Qgroup < ActiveRecord::Base
    belongs_to :quote
    has_many :qlines, :dependent => :destroy

    accepts_nested_attributes_for :qlines

    after_create :create_nested_records    


    default_scope { order('group_order ASC') }
    
    private
    
    def create_nested_records
      line = Mjbook::Qline.create(:qgroup_id => self.id)
    end

    
  end
end
