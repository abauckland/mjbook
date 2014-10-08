module Mjbook
  class Servicecategory < ActiveRecord::Base
    has_many :services
    belongs_to :company

    validates :name, presence: true

  end
end
