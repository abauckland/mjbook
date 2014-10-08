Mjbook::Engine.routes.draw do

  
  resources :invoiceterms

  resources :quoteterms

  resources :terms

  resources :hmrcexpcats

  resources :units

  resources :vats

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

  resources :quotes do
    get :print, :on => :member
  end

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


  resources :payments do
    get :business_paid, :on => :member 
    get :personal_paid, :on => :member
    get :salary_paid, :on => :member   
  end

 get 'pay_business', :to => 'payments#pay_business'
 get 'pay_personal', :to => 'payments#pay_personal'
 get 'pay_salary', :to => 'payments#pay_salary' 
 
  resources :products
  resources :productcategories

  resources :services
  resources :servicecategories

  resources :rates
  resources :ratecategories

  resources :miscs
  resources :misccategories

  resources :mileages do
    get :add_to_expenses, :on => :member  
  end

  resources :mileagemodes, :only => [:edit, :update, :create]

  resources :suppliers

  resources :customers

  resources :projects
  
  resources :expenseexpends
  
  resources :pendingexpends
end
