module Mjbook
  class ExpensePolicy < Struct.new(:user, :record)
  
    class Scope < Struct.new(:user, :scope)
      def resolve
          scope.joins(:project).where('mjbook_projects.company_id' => user.company_id)
      end
    end
   
      def business?
        true
      end
      
      def personal?
        index
      end

      def employee?
        index
      end    

      def show?
        index
      end 
            
      def new_business?
        index
      end
  
      def new_personal?
        index
      end
      
      def edit_business?
        index
      end 

      def create?
        index
      end       

      def update?
        index
      end 
      
      def destroy?
        index
      end       

      def accept?
        index
      end 
            
      def reject?
        index
      end 
  end
end