module Mjbook
  class Paymethod < ActiveRecord::Base
    has_many :expends
    has_many :payments
    has_many :transfers
  end
end
