module Mjbook
  class ExpendPolicy < Struct.new(:user, :record)

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

      def pay_personal?
        index?
      end

      def pay_business?
        index?
      end

      def pay_salary?
        index?
      end

      def pay_miscexpense?
        index?
      end

      def create?
        index?
      end

      def edit?
        index?
      end

      def update?
        index?
      end

      def destroy?
        index?
      end

      def reconcile?
        index?
      end

      def unreconcile?
        index?
      end
  end
end