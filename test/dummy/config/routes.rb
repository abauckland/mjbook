Rails.application.routes.draw do

  mount Mjbook::Engine => "/mjbook"
  
  resources :dashboards, :only => [:index]
   
end
