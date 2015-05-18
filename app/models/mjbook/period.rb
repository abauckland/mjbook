module Mjbook
  class Period < ActiveRecord::Base
    has_many :journals
  end
end
