module Mjbook
  class Qline < ActiveRecord::Base
    belongs_to :qgroup
    belongs_to :unit
    belongs_to :vat
    
    default_scope { order('line_order ASC') }
    
  end
end
