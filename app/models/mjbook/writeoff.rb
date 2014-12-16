module Mjbook
  class Writeoff < ActiveRecord::Base
    
    has_many :writeoffitems, :dependent => :destroy
    belongs_to :company    
  end
end
