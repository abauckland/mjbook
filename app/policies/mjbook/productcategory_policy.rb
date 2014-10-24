module Mjbook
  class ProductcategoryPolicy < Struct.new(:user, :record)
  
    class Scope < Struct.new(:user, :scope)
      def resolve
          scope.where(:company_id => user.company_id) 
      end
    end
            
    def index?
      true
    end
  
    def cat_options?
      index
    end

    def new?
      index
    end

    def edit?
      index
    end

    def create?
      index
    end

    def update?
      index
    end

    def delete?
      index
    end

  end
end