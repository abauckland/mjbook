module Mjbook
  class Donation < ActiveRecord::Base
        has_many :donors
        has_many :participants
  end
end
