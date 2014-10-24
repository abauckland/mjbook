module Mjbook
  class QuotePolicy < Struct.new(:user, :record)
  
    class Scope < Struct.new(:user, :scope)
      def resolve
          scope.joins(:project).where('mjbook_projects.company_id' => user.company_id)
      end
    end
   
      def index?
        true
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
      
      def delete?
        index
      end 

      def accept?
        index
      end       
      
      def reject?
        index
      end 

      def print?
        index
      end 
  end
end