module ApplicationHelper
  
    def pounds(price)
      number_to_currency(price, :unit => "£")
    end
  
end
