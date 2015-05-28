module Mjbook
  class WriteoffPolicy < Struct.new(:user, :record)

    class Scope < Struct.new(:user, :scope)
      def resolve
          scope.where(:company_id => user.company_id)
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

      def create?
        index?
      end

      def destroy?
        index?
      end

  end
end