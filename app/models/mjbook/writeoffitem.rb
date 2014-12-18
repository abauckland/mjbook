module Mjbook
  class Writeoffitem < ActiveRecord::Base

    belongs_to :writeoff
    belongs_to :inline

  end
end
