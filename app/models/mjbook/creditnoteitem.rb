module Mjbook
  class Creditnoteitem < ActiveRecord::Base

    belongs_to :creditnote
    belongs_to :inline

  end
end
