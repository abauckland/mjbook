    @period = Period.where(:id => params[:period_id]).first
    start_time = @period.year_start
    end_time = 1.year.from_now(@period.year_start)

    @summaries = policy_scope(Summary)

    if params[:companyaccount_id]
      if params[:companyaccount_id] != ""
        @summaries = @summaries.where(:companyaccount_id => params[:companyaccount_id])
      end

      if params[:date_from] != ""
        @summaries = @summaries.where('date > ?', params[:date_from])
      else
        @summaries = @summaries.where('date > ?', start_time)
      end

      if params[:date_to] != ""
        @summaries = @summaries.where('date < ?', params[:date_to])
      else
        @summaries = @summaries.where('date < ?', end_time)
      end
    end

    if params[:commit] == 'pdf'          
      pdf_business_index(@summaries, params[:companyaccount_id], params[:date_from], params[:date_to])
    end

    if params[:commit] == 'csv'          
      csv_business_index(@summaries, params[:companyaccount_id], params[:date_from], params[:date_to])
    end