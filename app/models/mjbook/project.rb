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

    def title=(text)
      super(text.downcase)
    end


    def name
      return ref+' '+title
    end    

    private

    default_scope { order('update_at DESC') }

  end
end
