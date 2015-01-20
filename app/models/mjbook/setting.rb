module Mjbook
  class Setting < ActiveRecord::Base

    belongs_to :company

    validates :email_domain, :email_username, :email_password, :yearend, presence: true

    def email_domain=(text)
      super(text.downcase)
    end

    def email_username=(text)
      super(text.downcase)
    end

    def email_password=(text)
      super(text.downcase)
    end

    
  end
end
