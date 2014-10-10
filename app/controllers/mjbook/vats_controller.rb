module Mjbook
  class VatsController < ActionController::Base

    def vat_options
      @vats = Vat.all
  
      #create hash of options
      @vat_options = {}
      
      @vats.each do |u|
        key = u.id
        value = u.cat
        @vat_options[key] = value
      end
      #render as json for jeditable
      render :json => @vat_options
    end
    
  end
end
