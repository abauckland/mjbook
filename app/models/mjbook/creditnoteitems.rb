module Mjbook
  class Creditnoteitems < ActiveRecord::Base
  
    belongs_to :creditnote
    belongs_to :inline
  
  end
end
