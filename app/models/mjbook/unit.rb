module Mjbook
  class Unit < ActiveRecord::Base
    has_many :qlines
  end
end
