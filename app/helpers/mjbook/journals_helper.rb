module Mjbook
  module JournalsHelper

    def original_payment_period(paymentitem_id)
      payment = Mjbook::Payment.joins(:paymentitems).where('mjbook_paymentitems.id' => paymentitem_id).first
      period = policy_scope(Period).where("year_start <= ? AND year_start > ?", payment.date, 1.year.ago(payment.date)).first
      return period.period
    end

    def original_expend_period(expenditem_id)
      expend = Mjbook::Expend.joins(:expenditems).where('mjbook_expenditems.id' => expenditem_id).first
      period = policy_scope(Period).where("year_start <= ? AND year_start > ?", expend.date, 1.year.ago(expend.date)).first
      return period.period
    end

  end
end
