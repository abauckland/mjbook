module Mjbook
  class Customer < ActiveRecord::Base

   #relationship with model in main app
    belongs_to :company    
    has_many :projects
    

    validates :company_name,
      presence: true,
      format: { with: CITY_REGEXP, message: "please enter a valid name" },
      uniqueness: {:scope => [:company_id]}

    validates :title,
      allow_blank: true,
      format: { with: NAME_REGEXP, message: "please enter a valid title" }

    validates :first_name, :surname,
      allow_blank: true,
      format: { with: NAME_REGEXP, message: "please enter a valid name" }

    validates :position,
      allow_blank: true,
      format: { with: NAME_REGEXP, message: "please enter a valid position description" }

    validates :address_1, :address_2,
      allow_blank: true,
      format: { with: CITY_REGEXP, message: "please enter a valid city name" }

    validates :city, :county,
      allow_blank: true,
      format: { with: CITY_REGEXP, message: "please enter a valid city name" }

    validates :postcode,
      allow_blank: true#,
#      format: { with: POSTCODE_REGEXP, message: "please enter a valid postcode, including a space between the area and street codes e.g.SK2 6PL" }

    validates :phone, :alt_phone,
      allow_blank: true,
      format: { with: PHONE_REGEXP, message: "please enter a valid phone number. Phone number should start with a '0'" }

    validates :email,
      allow_blank: true,
      format: { with: EMAIL_REGEXP, message: "please enter a email address" }


    def company_name=(text)
      super(text.downcase)
    end

    def title=(text)
      super(text.downcase)
    end

    def first_name=(text)
      super(text.downcase)
    end

    def surname=(text)
      super(text.downcase)
    end

    def position=(text)
      super(text.downcase)
    end

    def address_1=(text)
      super(text.downcase)
    end

    def address_2=(text)
      super(text.downcase)
    end

    def city=(text)
      super(text.downcase)
    end

    def county=(text)
      super(text.downcase)
    end

    def country=(text)
      super(text.downcase)
    end

    def email=(text)
      super(text.downcase)
    end

   
    def name
      return title+' '+first_name+' '+surname
    end
      
  end
end
