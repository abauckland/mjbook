Mjbook::Engine.routes.draw do

  
  resources :qlines do
    put :update_text
    put :update_vat
    put :update_rate
    put :update_unit
    put :update_quantity
    put :update_item
    put :update_cat
  end

  resources :qgroups

  resources :quotes

  resources :summaries

  resources :expenses do
   # get :personal
    get :edit_personal, :on => :member
    get :edit_business, :on => :member

    get :accept, :on => :member
    get :reject, :on => :member      
  end

 get 'business', :to => 'expenses#business'
 get 'new_business', :to => 'expenses#new_business'
 get 'personal', :to => 'expenses#personal' 
 get 'new_personal', :to => 'expenses#new_personal'

 get 'employee', :to => 'expenses#employee'


  resources :processexpenses do
    get :index_personal, :on => :member 
    get :accept_expense, :on => :member
    get :reject_expense, :on => :member   
  end


  resources :products do
    get :list_products, :on => :member    
  end

  resources :productcategories do
    get :list_categories, :on => :member
  end

  resources :mileages do
    get :add_to_expenses, :on => :member  
  end

  resources :mileagemodes, :only => [:edit, :update, :create]

  resources :suppliers

  resources :customers

  resources :projects
  
  resources :expenseexpends

  resources :expenditures
  
  resources :pendingexpends
end
