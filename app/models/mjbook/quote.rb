module Mjbook
  class Quote < ActiveRecord::Base
    has_many :qgroups, :dependent => :destroy

    belongs_to :project
    
    accepts_nested_attributes_for :qgroups
    
    after_create :create_nested_records

    enum status: [:submitted, :accepted, :rejected, :invoiced]

    private
    
    def create_nested_records
 #     self.qgroups.build
 #     qgroups.qlines.build
    end
    
  end
end
