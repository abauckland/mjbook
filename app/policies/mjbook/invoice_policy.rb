module Mjbook
  class InvoicePolicy < Struct.new(:user, :record)

    class Scope < Struct.new(:user, :scope)
      def resolve
          scope.joins(:project).where('mjbook_projects.company_id' => user.company_id)
      end
    end

      def owned
        record.company_id == user.company_id
      end

      def index?
        true
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

      def edit?
        index?
      end

      def update?
        index?
      end

      def destroy?
        index?
      end

      def print?
        index?
      end

      def email?
        index?
      end

  end
end