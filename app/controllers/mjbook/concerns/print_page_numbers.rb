
  module PrintQuote
    extend ActiveSupport::Concern
    
    def index_table_page_numbers(pdf)
      page_string = "<page> of <total>"      
      options = {:at => [175.mm, 202.mm],
        :width => 15.mm,
        :align => :left,
        :start_count_at => 1,
        :size => 8
        }
      
      pdf.number_pages page_string, options
    end

  end