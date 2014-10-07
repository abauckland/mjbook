module Mjbook
  class Qline < ActiveRecord::Base
    belongs_to :qgroup
  end
end
