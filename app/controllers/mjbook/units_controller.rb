module Mjbook
  class UnitsController < ActionController::Base

  def unit_options
    @units = Unit.all

     #create hash of options
    @unit_options = {}
    
    @units.each do |u|
      key = u.id
      value = u.text
      @unit_options[key] = value
    end
    #render as json for jeditable
    render :json => @unit_options       
  end
    
  end
end
