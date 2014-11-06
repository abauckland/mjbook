module Mjbook
  class Mileage < ActiveRecord::Base
    
    belongs_to :mileagemode
    belongs_to :hmrcexpcat
    belongs_to :project
    belongs_to :user
    has_one :expense

    validates :project_id, :date, :mileagemode_id, :start, :finish, presence: true
    
  end
end
