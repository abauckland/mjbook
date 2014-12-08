  module PrintIndexes
    
    extend ActiveSupport::Concern

    include PrintIndexHeader
    include PrintIndexTable
    include PrintIndexFooter
    
    def table_indexes(data, index, filter_group, date_from, date_to, filename, pdf) 

      ##HEADERS
      index_header(index, filter_group, date_from, date_to, pdf) 

      ##INDEX_TABLE
      index_table(data, index, pdf) 
    
      ##FOOTERS      
      index_footer(filename, pdf) 

      ##PAGE NUMBERING
#      index_table_page_numbers(pdf)      
      
    end

   
#    def index_table_page_numbers(pdf)
#      string = "page <page> of <total>"      
#      options = {:at => [277.mm, 6.mm],
#        :width => 20.mm,
#        :align => :right,
#        :start_count_at => 1
#        }
#      
#      number_pages string options
#    end 

end  