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


    def self.to_csv

      require 'csv'

      CSV.generate do |csv|
        csv << ["Date", "Job Ref", "Mode", "Start Location", "Destination", "Return Trip", "Distance"]
        all.each do |set|
          csv << [
                 set.date,
                 set.project.ref,
                 set.mileagemethod.mode,
                 set.start,
                 set.finish,
                 set.return,
                 set.distance,
                 ]

        end
      end
    end



  end
end
