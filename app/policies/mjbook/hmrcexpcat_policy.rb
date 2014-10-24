module Mjbook
  class HmrcexpcatPolicy < Struct.new(:user, :record)
  
    class Scope < Struct.new(:user, :scope)
      def resolve
        if user.owner? || user.admin?   
          scope.where(:company_id => user.company_id)
        end   
      end
    end
            
    def index?
      user.owner? || user.admin? 
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

  end
end