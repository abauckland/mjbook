module Mjbook
  class Vat < ActiveRecord::Base
    has_many :qlines
    has_many :inlines
  end
end
