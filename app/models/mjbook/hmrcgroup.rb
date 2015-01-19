module Mjbook
  class Hmrcgroup < ActiveRecord::Base    

    has_many :hmrcexpcats

    private

      default_scope { order('group ASC') }

  end
end
