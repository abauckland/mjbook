module Mjbook
  class Mileage < ActiveRecord::Base
    
    belongs_to :mileagemode
    belongs_to :hmrcexpcat
    belongs_to :project
    belongs_to :user
    has_one :expense, :validate => false

    accepts_nested_attributes_for :expense

    before_save :assign_values
    before_save :assign_dates

    validates :project_id, :mileagemode_id, :start, :finish, presence: true
    validates :distance, presence: true, numericality: true
    validates :travel_date,
      presence: true,
      format: { with: DATE_REGEXP, message: "please enter a valid date in the format dd/mm/yyyy" }


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


    private
      def assign_values

        mode = Mjbook::Mileagemode.find(:id => @mileagemode_id)
        rate= mode.rate.to_d

        self.price = @distance*rate
        self.vat = 0
        self.total = @distance*rate

      end

      def assign_dates
        self.date = Time.now
        self.due_date = Time.now.utc.end_of_month
      end

  end
end
