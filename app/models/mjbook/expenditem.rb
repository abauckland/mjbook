module Mjbook
  class Expenditem < ActiveRecord::Base

    belongs_to :expend
    belongs_to :expense
    belongs_to :salary
    belongs_to :transfer
    belongs_to :miscexpense

    has_one :journal

  end
end
