module Mjbook
  class Misc < ActiveRecord::Base
    belongs_to :misccategory
    belongs_to :company

    validates :misccategory_id, presence: true
    validates :item, presence: true

  end
end
