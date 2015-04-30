module Mjbook
  class Mjbook::ApplicationController < ActionController::Base
   layout "mjbook/books"
   include Pundit

  def current_user
    @current_user = User.first
  end
  
  helper_method :current_user 
            
      def clean_text(value)
        @value = value 
        @value.strip
        @value = @value.gsub(/\n/,"")
        @value.chomp
        @value.chomp   
        while [",", ";", "!", "?"].include?(value.last)
          @value.chop!
        end
      end

      def clean_number(value)
        @value = value 
        @value.strip
        @value = @value.gsub(/\n/,"")
        @value.chomp
        @value.chomp   
        while [".", ",", ";", "!", "?"].include?(value.last)
          @value.chop!
        end
        @value = @value.to_d
      end



      def accounting_period(date)
        @period = policy_scope(Period).where("year_start <= ? AND year_start > ?", date, 1.year.ago(date)).first

        #if record does not exist create period record
        if @period.blank?

          last_period = policy_scope(Period).order(:year_start).last

          if date > last_period.year_start
            difference = (date - last_period.year_start) / 1.year
            years_difference = (difference - 0.5).round

            start_date = years_difference.year.from_now(last_period.year_start)
          #if date < first_period
          else
            first_period = policy_scope(Period).order(:year_start).first

            difference = (first_period.year_start - date) / 1.year
            years_difference = (difference + 0.5).round

            start_date = years_difference.year.ago(first_period.year_start)
          end

          start_year = start_date.strftime("%Y")
          end_year = 1.year.from_now(start_date).strftime("%Y")
          period_name = start_year + "/" + end_year

          #create record for period
          @period = Period.create(:company_id => current_user.company_id,
                                 :period => period_name,
                                 :year_start => start_date,
                                 :retained => 0
                                 )
        end
      end

  end
end
