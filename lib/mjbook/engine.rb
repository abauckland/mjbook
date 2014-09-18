module Mjbook
  class Engine < ::Rails::Engine
    isolate_namespace Mjbook

    initializer :assets do |config|
      Rails.application.config.assets.paths << root.join("app", "assets", "images", "mjbook")
    end

  end
end
