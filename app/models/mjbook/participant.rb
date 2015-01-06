module Mjbook
  class Participant < ActiveRecord::Base
        belongs_to :donation
  end
end
