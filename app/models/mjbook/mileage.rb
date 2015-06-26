module Mjbook
  class Mileage < ActiveRecord::Base
    
    belongs_to :mileagemode
    belongs_to :hmrcexpcat
    belongs_to :project
    belongs_to :user
    belongs_to :expense

    validates :mileagemode_id, :start, :finish, presence: true
    validates :distance, presence: true, numericality: true


    def self.to_csv

      require 'csv'

      CSV.generate do |csv|
        csv << ["Date", "Job Ref", "Mode", "Start Location", "Destination", "Return Trip", "Distance"]
        all.each do |set|
          csv << [
                 set.travel_date,
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
