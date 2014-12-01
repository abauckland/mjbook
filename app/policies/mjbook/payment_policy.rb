module Mjbook
  class PaymentPolicy < Struct.new(:user, :record)
  
    class Scope < Struct.new(:user, :scope)
      def resolve
          scope.joins(:project).where('mjbook_projects.company_id' => user.company_id)
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

      def create?
        index
      end 
            
      def edit?
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

      def unreconcile?
        index
      end  

  end
end