module Mjbook
  class Project < ActiveRecord::Base

    belongs_to :company

    has_many :mileages
    belongs_to :invoicemethod
    has_many :expenses
        
    has_many :quotes
    has_many :invoices
    has_many :payments

    belongs_to :customer

    validates :customer_id, :invoicemethod_id, presence: true
    validates :ref, :title,
      format: { with: ADDRESS_REGEXP, message: ": please enter a ref/name with alphabetical or numerical characters" }    
    validates :company_id, uniqueness: {:scope => [:ref, :title, :customer_id]}

    def name
      return ref+' '+title
    end


    def self.to_csv

      require 'csv'

      CSV.generate do |csv|
        csv << ["Ref", "Title", "Company", "Cust. Ref", "Contact Name", "Description"]
        all.each do |set|
          csv << [
                 set.ref,
                 set.title,
                 set.customer.company_name,
                 set.customer_ref,
                 set.customer.name,
                 set.description,
                 ]

        end
      end
    end

    private

    default_scope { order('updated_at DESC') }

  end
end
