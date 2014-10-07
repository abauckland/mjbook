module Mjbook
  class Qgroup < ActiveRecord::Bas
    belongs_to :quote
    has_many :qlines, :dependent => :destroy

    accepts_nested_attributes_for :qlines

    after_initialize :create_nested_records

    
    
    private
    
    def create_nested_records
      self.qlines.build
    end
    
  end
end
