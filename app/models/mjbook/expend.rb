module Mjbook
  class Expend < ActiveRecord::Base
    
    enum status: [:paid, :reconciled]
    
  end
end
