module Mjbook
  class Inline < ActiveRecord::Base

    belongs_to :ingroup
    belongs_to :unit
    belongs_to :vat
    
    default_scope { order('line_order ASC') }
    
  end
end
