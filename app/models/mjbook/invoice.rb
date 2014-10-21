module Mjbook
  class Invoice < ActiveRecord::Base
    has_many :ingroups, :dependent => :destroy

    belongs_to :project
    belongs_to :invoiceterm
    belongs_to :invoicetype
    
    accepts_nested_attributes_for :ingroups
    
    after_create :create_nested_records

    enum status: [:submitted, :accepted, :rejected, :paid]

    validates :project_id, presence: true
    validates :ref, presence: true    

    private

    default_scope { order('date DESC') }
    
    def create_nested_records
      Mjbook::Ingroup.create(:invoice_id => self.id)
    end

  end
end
