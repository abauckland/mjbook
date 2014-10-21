module Mjbook
  class Unit < ActiveRecord::Base
    has_many :qlines
    has_many :inlines
  end
end
