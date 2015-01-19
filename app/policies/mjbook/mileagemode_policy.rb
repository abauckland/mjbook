module Mjbook
  class MileagemodePolicy < Struct.new(:user, :record)
  
    class Scope < Struct.new(:user, :scope)
      def resolve
        if user.owner? || user.admin?
          scope.where(:company_id => user.company_id)
        end
      end
    end

    def owned
      record.company_id == user.company_id
    end

    def edit?
      if owned
        user.owner? || user.admin?
      end
    end
  
    def update?
      edit?
    end

  end
end