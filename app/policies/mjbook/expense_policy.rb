module Mjbook
  class ExpensePolicy < Struct.new(:user, :record)
  
    class Scope < Struct.new(:user, :scope)
      def resolve
          scope.joins(:project).where('mjbook_projects.company_id' => user.company_id)
      end
    end
       
      def accept?
        user.owner? || user.admin?
      end 
            
      def reject?
        accept?
      end 
  end
end