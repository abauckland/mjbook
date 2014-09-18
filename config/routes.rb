Mjbook::Engine.routes.draw do

  
  resources :dashboards
 
  resources :businessexpenses do
    get :accept_expense, :on => :member
    get :reject_expense, :on => :member  
  end
  
  resources :personalexpenses do
    get :accept_expense, :on => :member
    get :reject_expense, :on => :member  
  end

  resources :processexpenses do
    get :index_personal, :on => :member 
    get :accept_expense, :on => :member
    get :reject_expense, :on => :member   
  end


  resources :products

  resources :productcategories

  resources :mileages do
    get :add_to_expenses, :on => :member  
  end

  resources :mileagemodes, :only => [:edit, :update, :create]

  resources :suppliers

  resources :customers

  resources :projects
  
  resources :expenseexpends

  resources :expenditures do
    get :pay_personal_expenses, :on => :member
    get :pay_business_expenses, :on => :member 
  end

end
