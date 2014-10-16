module Mjbook
  class Ingroup < ActiveRecord::Base

    belongs_to :invoice
    has_many :Inlines, :dependent => :destroy

    accepts_nested_attributes_for :Inlines

    after_create :create_nested_records    


    default_scope { order('group_order ASC') }
    
    private
    
    def create_nested_records
      line = Mjbook::Inline.create(:ingroup_id => self.id)
    end

  end
end
