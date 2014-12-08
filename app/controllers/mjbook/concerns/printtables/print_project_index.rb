module Printtables
  module PrintProjectIndex
     
    def project_column_widths
      [17.mm, 50.mm, 50.mm, 18.mm, 50.mm, 92.mm]
    end
  
    def project_headers
      ["Ref", "Title", "Company", "Cust. Ref", "Contact Name", "Description"]
    end
  
    def project_data(data, rows)
        data.each_with_index do |set, i|
          rows[i+1] = [
                       set.ref,
                       set.title,
                       set.customer.company_name,
                       set.customer_ref,
                       set.customer.name,
                       set.description,
                       ]
        end 
    end
  
  end
end