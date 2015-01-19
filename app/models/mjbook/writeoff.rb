module Mjbook
  class Writeoff < ActiveRecord::Base

    has_many :writeoffitems, :dependent => :destroy
    belongs_to :company

    private

    default_scope { order('date DESC') }

  end
end
