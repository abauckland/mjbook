module Mjbook
  class Hmrcexpcat < ActiveRecord::Base

    belongs_to :company    
    belongs_to :hmrcgroup
    
    has_many :mileages
    has_many :expenses 

    validates :hmrcgroup_id, presence: true

    validates :category,
      presence: true,
      format: { with: ADDRESS_REGEXP, message: "please enter a valid name" },
      uniqueness: {:scope => [:company_id, :hmrcgroup_id]}

    private

      default_scope { order('category ASC') }

  end
end
