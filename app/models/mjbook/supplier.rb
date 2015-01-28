module Mjbook
  class Supplier < ActiveRecord::Base
   
    #relationship with model in main app
    belongs_to :company        
    has_many :expenses

    validates :company_name,
      presence: true,
      format: { with: CITY_REGEXP, message: "please enter a valid name" },
      uniqueness: {:scope => [:company_id]}

    validates :vat_no,
      allow_blank: true,
      uniqueness: {message: "a company with this vat number is already in use"},
      format: { with: REG_REGEXP, message: "please enter a valid vat number. Omit any spaces and where 'GB' prefix is included (optional) this must be capitals" }

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
      format: { with: ADDRESS_REGEXP, message: "please enter a valid city name" }

    validates :city, :county,
      allow_blank: true,
      format: { with: CITY_REGEXP, message: "please enter a valid city name" }

    validates :postcode,
      allow_blank: true,
      format: { with: POSTCODE_REGEXP, message: "please enter a valid postcode, including a space between the area and street codes e.g.SK2 6PL" }

    validates :phone, :alt_phone,
      allow_blank: true,
      format: { with: PHONE_REGEXP, message: "please enter a valid phone number. Phone number should start with a '0'" }

    validates :email,
      allow_blank: true,
      format: { with: EMAIL_REGEXP, message: "please enter a email address" }

    def name
      return title+' '+first_name+' '+surname
    end

    def self.to_csv

      require 'csv'

      CSV.generate do |csv|
        csv << ["Name", "Position", "Address", "Tel", "Alt Tel", "Email", "Company", "VAT No.", "Notes"]
        all.each do |set|
          csv << [
                 set.name,
                 set.position,
                 [set.address_1, set.address_2, set.city, set.county, set.country, set.postcode],
                 set.phone,
                 set.alt_phone,
                 set.email,
                 set.company_name,
                 set.vat_no,
                 set.notes
                 ]

        end
      end
    end


    private

      default_scope { order('company_name ASC') }

  end
end
