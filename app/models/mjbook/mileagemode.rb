module Mjbook
  class Mileagemode < ActiveRecord::Base
      has_many :mileages
      belongs_to :company
        

      validates :project_id, presence: true
      validates :date, presence: true
      validates :mileagemethod_id, presence: true      
      validates :start, presence: true
      validates :finsh, presence: true
      validates :distance, presence: true, numericality: true        
        
  end
end
