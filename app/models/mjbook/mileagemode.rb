module Mjbook
  class Mileagemode < ActiveRecord::Base
    has_many :mileages
    belongs_to :company

    validates :rate, presence: true, numericality: true

  end
end
