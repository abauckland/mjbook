module Mjbook
  class Qline < ActiveRecord::Base
    belongs_to :qgroup
    belongs_to :unit
    belongs_to :vat
    
  end
end
