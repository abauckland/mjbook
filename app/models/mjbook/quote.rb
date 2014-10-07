module Mjbook
  class Quote < ActiveRecord::Base
    has_many :qgroups, :dependent => :destroy
    
    accepts_nested_attributes_for :qgroups
    
    after_initialize :create_nested_records



    private
    
    def create_nested_records
      self.qgroups.build
      qgroups.qlines.build
    end
    
  end
end
