module Mjbook
  class Invoicetype < ActiveRecord::Base
    has_many :invoices
  end
end
