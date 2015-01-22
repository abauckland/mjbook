module Mjbook
  class ExpensePolicy < Struct.new(:user, :record)

    class Scope < Struct.new(:user, :scope)
      def resolve
          scope.where(:company_id => user.company_id)
      end
    end

    def owned
      record.company_id == user.company_id
    end

    def accept?
      if owned
        user.owner? || user.admin?
      end
    end

    def reject?
      accept?
    end
  end
end