module Mjbook
  class Writeoffitems < ActiveRecord::Base

    belongs_to :writeoff
    belongs_to :inline

  end
end
