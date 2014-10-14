module Mjbook
  class Engine < ::Rails::Engine
    isolate_namespace Mjbook

#   config.to_prepare do
#      Dir.glob(Rails.root + "app/decorators/**/*_decorator*.rb").each do |c|
#        require_dependency(c)
#      end
#    end



    initializer :assets do |config|
      Rails.application.config.assets.paths << root.join("app", "assets", "images", "mjbook")
    end

  end
end
