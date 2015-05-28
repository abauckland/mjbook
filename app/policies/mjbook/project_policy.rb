module Mjbook
  class ProjectPolicy < Struct.new(:user, :record)

    class Scope < Struct.new(:user, :scope)
      def resolve
          scope.where(:company_id => user.company_id)
      end
    end

    def owned
      true
    end

    def index?
      true
    end

    def show?
      owned
    end

    def new?
      index?
    end

    def edit?
      owned
    end

    def create?
      index?
    end

    def update?
      owned?
    end

    def destroy?
      owned
    end

  end
end