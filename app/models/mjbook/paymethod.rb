module Mjbook
  class Paymethod < ActiveRecord::Base
    has_many :expends
  end
end
