module Printtables
  module PrintMileageIndex
     
    def mileage_column_widths
      [18.mm, 18.mm, 25.mm, 83.mm, 83.mm, 25.mm, 25.mm]
    end
  
    def mileage_headers
      ["Date", "Job Ref", "Mode", "Start Location", "Destination", "Return Trip", "Distance"]
    end
  
    def mileage_data(data, rows)
        data.each_with_index do |set, i|
          rows[i+1] = [
                       set.date,
                       set.project.ref,
                       set.mileagemethod.mode,
                       set.start,
                       set.finish,
                       set.return,
                       set.distance,
                       ]
        end 
    end
  
  end
end