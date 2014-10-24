module Mjbook
  class MileagemodePolicy < Struct.new(:user, :record)
  
    class Scope < Struct.new(:user, :scope)
      def resolve
        if user.owner? || user.admin?
          scope.where(:company_id => user.company_id)
        end
      end
    end
            
    def edit?
      user.owner? || user.admin?
    end
  
    def update?
      user.owner? || user.admin?
    end

  end
end