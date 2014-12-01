module Mjbook
  class Supplier < ActiveRecord::Base
   
    #relationship with model in main app
    belongs_to :company        
    has_many :expenses

    validates :company_name,
      presence: true,
      format: { with: NAME_REGEXP, message: "please enter a valid name" },
      uniqueness: {:scope => [:company_id]}

    validates :vat_no,
      uniqueness: {message: "a company with this vat number is already in use"},
      format: { with: REG_REGEXP, message: "please enter a valid vat number. Omit any spaces and where 'GB' prefix is included (optional) this must be capitals" }

    validates :title,
      format: { with: NAME_REGEXP, message: "please enter a valid title" }

    validates :first_name, :surname,
      format: { with: NAME_REGEXP, message: "please enter a valid name" }

    validates :position,
      format: { with: NAME_REGEXP, message: "please enter a valid position description" }

    validates :address_1, :address_2,
      format: { with: CITY_REGEXP, message: "please enter a valid city name" }

    validates :city, :county,
      format: { with: CITY_REGEXP, message: "please enter a valid city name" }

    validates :postcode,
      format: { with: POSTCODE_REGEXP, message: "please enter a valid postcode, including a space between the area and street codes e.g.SK2 6PL" }

    validates :tel, :alt_tel,
      format: { with: PHONE_REGEXP, message: "please enter a valid phone number. Phone number should start with a '0'" }

    validates :email,
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
