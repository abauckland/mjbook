module Mjbook
  class Creditnote < ActiveRecord::Base

    include AASM
    
    has_many :creditnoteitems, :dependent => :destroy
    belongs_to :company    

    aasm :column => 'state' do

      state :draft, :initial => true
      state :confirmed

      event :confirm do
        transitions :from => :draft, :to => :confirmed
      end
  
    end

    def self.to_csv

      require 'csv'

      CSV.generate do |csv|
        csv << ["Reference","Price", "VAT", "Total", "Date", "Status", "Notes"]
        all.each do |set|
          csv << [
                 set.ref,
                 #set.creditnoteitem.inline.ingroup.invoice.ref
                 #set.creditnoteitem.inline.ingroup.invoice.project.customer.company_name
                 set.price,
                 set.vat,
                 set.total,
                 set.date.strftime("%d/%m/%y"),
                 set.notes
                 ]
        end
      end
    end


    private

    default_scope { order('date DESC') }

  end
end
