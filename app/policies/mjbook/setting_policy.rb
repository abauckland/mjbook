module Mjbook
  class SettingPolicy < Struct.new(:user, :record)

    def owned
      record.company_id == user.company_id
    end

    def edit?
      if owned
        user.owner? || user.admin?
      end
    end
  
    def update?
      edit?
    end

  end
end