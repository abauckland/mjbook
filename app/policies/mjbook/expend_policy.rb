module Mjbook
  class ExpendPolicy < Struct.new(:user, :record)
  
    class Scope < Struct.new(:user, :scope)
      def resolve
          scope.where(:company => user.company_id)
      end
    end
   
      def index?
        user.owner? || user.admin?
      end
      
      def show?
        index
      end

      def new?
        index
      end    

      def new_personal?
        index
      end 

      def create?
        index
      end 
            
      def edit?
        index
      end

      def edit_personal?
        index
      end
  
      def update?
        index
      end
      
      def destroy?
        index
      end 

      def reconcile?
        index
      end       

  end
end