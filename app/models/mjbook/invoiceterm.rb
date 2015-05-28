module Mjbook
  class Invoiceterm < ActiveRecord::Base
    has_many :invoices

    validates :ref, :terms, presence: true
    validates :period, presence: true, numericality: true

    def self.to_csv

      require 'csv'

      CSV.generate do |csv|
        csv << ["Reference","Period (days)","Terms"]
        all.each do |set|
          csv << [
                 set.ref,
                 set.period,
                 set.terms
                 ]

        end
      end
    end

    private

      default_scope { order('period ASC') }

  end
end
