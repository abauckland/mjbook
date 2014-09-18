module Mjbook
  class Mileage < ActiveRecord::Base
    
    belongs_to :mileagemode
    belongs_to :hmrcexpcat
    belongs_to :project
    belongs_to :user

    
  end
end
