module Mjbook
  class Ratecategory < ActiveRecord::Base
    has_many :rates
    belongs_to :company

    validates :name, presence: true

  end
end
