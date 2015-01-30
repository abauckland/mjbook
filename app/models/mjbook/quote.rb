module Mjbook
  class Quote < ActiveRecord::Base
    
    include AASM

    has_many :qgroups, :dependent => :destroy

    belongs_to :project
    belongs_to :quoteterm
    
    accepts_nested_attributes_for :qgroups
    
#    after_create :create_nested_records


    aasm :column => 'state' do

      state :draft, :initial => true
      state :submitted
      state :rejected
      state :accepted
      state :invoiced

      event :submit do
        transitions :from => :draft, :to => :submitted
      end
  
      event :accept do
        transitions :from => :submitted, :to => :accepted
        transitions :from => :rejected, :to => :accepted
      end
  
      event :reject do
        transitions :from => :submitted, :to => :rejected
        transitions :from => :accepted, :to => :rejected
      end

      event :draft do
        transitions :from => :rejected, :to => :draft
        transitions :from => :draft, :to => :draft
      end
  
      event :invoice do
        transitions :from => :accepted, :to => :invoiced
      end
    
    end

    validates :project_id, :quoteterm_id, :ref, presence: true
    validates :date,
      presence: true,
      format: { with: DATE_REGEXP, message: "please enter a valid date in the format dd/mm/yyyy" }  

    def self.to_csv

      require 'csv'

      CSV.generate do |csv|
        csv << ["Job Ref", "Quote Ref", "Quote Title", "Cust. Ref", "Customer Name", "Customer Company", "Date", "Price", "VAT", "Total", "Status"]
        all.each do |set|
          csv << [
                 set.project.ref,
                 set.ref,
                 set.title,
                 set.customer_ref,
                 set.project.customer.name,
                 set.project.customer.company_name,
                 set.date.strftime("%d/%m/%y"),
                 number_to_currency(set.price, :unit => "£"),
                 number_to_currency(set.vat_due, :unit => "£"),
                 number_to_currency(set.total, :unit => "£"),
                 set.state
                 ]

        end
      end
    end


    private

    default_scope { order('date DESC') }
    
#    def create_nested_records
#      Mjbook::Qgroup.create(:quote_id => self.id)
#    end
    
  end
end
