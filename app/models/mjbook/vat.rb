module Mjbook
  class Vat < ActiveRecord::Base
    has_many :qlines
  end
end
