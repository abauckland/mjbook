module Mjbook
  class Mileage < ActiveRecord::Base
    
    belongs_to :mileagemode
    belongs_to :hmrcexpcat
    belongs_to :project
    belongs_to :user
    has_one :expense

    validates :project_id, :mileagemode_id, :start, :finish, presence: true
    validates :distance, presence: true, numericality: true
    validates :date,
      presence: true,
      format: { with: DATE_REGEXP, message: "please enter a valid date in the format dd/mm/yyyy" }

    def start=(text)
      super(text.downcase)
    end

    def finish=(text)
      super(text.downcase)
    end
    
  end
end
