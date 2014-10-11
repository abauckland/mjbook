module Mjbook
  class Quote < ActiveRecord::Base
    has_many :qgroups, :dependent => :destroy

    belongs_to :project
    
    accepts_nested_attributes_for :qgroups
    
    after_create :create_nested_records

    enum status: [:submitted, :accepted, :rejected, :invoiced]

    validates :project_id, presence: true
    validates :ref, presence: true    

    private
    
    def create_nested_records
      Mjbook::Qgroup.create(:quote_id => self.id)
    end


#    def create_nested_records
#      self.qgroups.build
#      qgroups.qlines.build
#    end
    
  end
end
