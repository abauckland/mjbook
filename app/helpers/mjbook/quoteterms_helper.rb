module Mjbook
  module QuotetermsHelper

    def quoteterm_in_use(quoteterm)
      term = Quote.where(:quoteterm_id => quoteterm.id).first
      if term.blank?
        true
      end
    end


  end
end
