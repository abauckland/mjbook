module Mjbook
  class BusinessesPolicy < Struct.new(:user, :business)

    def index?
      true
    end

    def show?
      user.owner? || user.admin?
    end

    def new?
      true
    end

    def edit?
      show?
    end

    def create?
      true
    end

    def update?
      show?
    end

    def destroy?
      show?
    end

  end
end