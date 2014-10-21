module Mjbook
  class Payment < ActiveRecord::Base

    belongs_to :invoice

    enum status: [:paid, :reconciled]

  end
end
