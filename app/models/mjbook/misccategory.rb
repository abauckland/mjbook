module Mjbook
  class Misccategory < ActiveRecord::Base
    has_many :miscs
    belongs_to :company

    validates :name, presence: true

  end
end
