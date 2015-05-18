module Mjbook
  class Journal < ActiveRecord::Base
    belongs_to :period
    belongs_to :paymentitem
    belongs_to :expenditem
    belongs_to :company
  end
end
