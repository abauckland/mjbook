module Mjbook
  class Quote < ActiveRecord::Base
    has_many :qgroups, :dependent => :destroy

    belongs_to :project
    belongs_to :quoteterm    
    
    accepts_nested_attributes_for :qgroups
    
    after_create :create_nested_records

    enum status: [:submitted, :accepted, :rejected, :invoiced]

    validates :project_id, presence: true
    validates :ref, presence: true    

    private

    default_scope { order('date DESC') }
    
    def create_nested_records
      Mjbook::Qgroup.create(:quote_id => self.id)
    end
    
  end
end
