module Mjbook
  class Payment < ActiveRecord::Base

    belongs_to :invoice

  end
end
