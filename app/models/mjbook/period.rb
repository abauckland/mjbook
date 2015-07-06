module Mjbook
  class Period < ActiveRecord::Base
    has_many :journals

    default_scope { order(:year_start) }

  end
end
