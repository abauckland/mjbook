module Mjbook
  class Writeoff < ActiveRecord::Base

    has_many :writeoffitems, :dependent => :destroy
    belongs_to :company


    def self.to_csv

      require 'csv'

      CSV.generate do |csv|
        csv << ["Reference","Price", "VAT", "Total", "Date", "Status", "Notes"]
        all.each do |set|
          csv << [
                 set.ref,
                 #set.writeoffitem.inline.ingroup.invoice.ref
                 #set.writeoffitem.inline.ingroup.invoice.project.customer.company_name
                 number_to_currency(set.price, :unit => "£"),
                 number_to_currency(set.vat, :unit => "£"),
                 number_to_currency(set.total, :unit => "£"),
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
