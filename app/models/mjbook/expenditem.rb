module Mjbook
  class Expenditem < ActiveRecord::Base

    belongs_to :expend
    belongs_to :expense
    belongs_to :salary
    belongs_to :transfer
    
  end
end
