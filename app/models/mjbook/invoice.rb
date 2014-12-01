module Mjbook
  class Invoice < ActiveRecord::Base

    include AASM

    has_many :ingroups, :dependent => :destroy

    belongs_to :project
    belongs_to :invoiceterm
    belongs_to :invoicetype
    
    accepts_nested_attributes_for :ingroups
    
    after_create :create_nested_records

    aasm :column => 'state' do

      state :submitted, :initial => true 
      state :rejected
      state :accepted
      state :paid
  
      event :accept do
        transitions :from => :submitted, :to => :accepted
        transitions :from => :rejected, :to => :accepted
      end
  
      event :reject do
        transitions :from => :submitted, :to => :rejected
        transitions :from => :accepted, :to => :rejected
      end
  
      event :pay do
        transitions :from => :accepted, :to => :paid
      end
  
      event :correct_payment do
        transitions :from => :paid, :to => :accepted
      end

    end

    validates :project_id, :invoiceterm_id, :invoicetype_id, :ref, presence: true
    validates :date,
      presence: true,
      format: { with: DATE_REGEXP, message: "please enter a valid date in the format dd/mm/yyyy" }  
  

    private

    default_scope { order('date DESC') }
    
    def create_nested_records
      Mjbook::Ingroup.create(:invoice_id => self.id)
    end

  end
end
