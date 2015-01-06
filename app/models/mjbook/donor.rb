module Mjbook
  class Donor < ActiveRecord::Base
        belongs_to :donation
  end
end
