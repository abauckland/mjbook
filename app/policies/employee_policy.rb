class EmployeePolicy < Struct.new(:user, :employee)

    def index?
      true
    end

    def show?
      index?
    end

end