module Mjbook
  class SalaryPolicy < Struct.new(:user, :record)
  
    class Scope < Struct.new(:user, :scope)
      def resolve
          scope.joins(:user).where('users.company_id' => user.company_id) 
      end
    end
            
    def index?
      user.owner? || user.admin?
    end
  
    def show?
      index?
    end

    def new?
      index?
    end

    def edit?
      index?
    end

    def create?
      index?
    end

    def update?
      index?
    end

    def destroy?
      index?
    end

    def accept?
      index?
    end 
            
    def reject?
      index?
    end 

  end
end