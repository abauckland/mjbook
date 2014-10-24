Mjbook::Engine.routes.draw do
  
  resources :companyaccounts

  resources :expends do
    get :new_personal, :on => :member
    get :edit_personal, :on => :member
    get :reconcile, :on => :member  
  end

  resources :salaries do
    get :reconcile, :on => :member
  end

  resources :payments do
    get :reconcile, :on => :member
  end

  resources :inlines do
    get :new_line, :on => :member
    get :edit_line, :on => :member
    get :delete_line, :on => :member
    member do
      put :update_text
      put :update_price
      put :update_vat
      put :update_vat_rate
      put :update_rate
      put :update_unit
      put :update_quantity
      put :update_item
      put :update_cat
    end
  end
  
  resources :ingroups do
    get :new_group, :on => :member
    get :delete_group, :on => :member
    member do
      put :update_text
    end
  end 

  resources :invoices do
    get :accept, :on => :member
    get :reject, :on => :member 
    get :print, :on => :member
  end

  resources :invoicecontents, :only => [:show]

  resources :invoiceterms, :only => [:index, :edit, :new, :create, :update, :destroy] do
    get :print, :on => :member
  end

  resources :quoteterms, :only => [:index, :edit, :new, :create, :update, :destroy] do
    get :print, :on => :member
  end

  resources :hmrcexpcats

  resources :units, :only => [] do
    get :unit_options, :on => :member
  end

  resources :vats, :only => [] do
    get :vat_options, :on => :member
  end

  resources :qlines do
    get :new_line, :on => :member
    get :edit_line, :on => :member
    get :delete_line, :on => :member
    member do
      put :update_text
      put :update_price
      put :update_vat
      put :update_vat_rate
      put :update_rate
      put :update_unit
      put :update_quantity
      put :update_item
      put :update_cat
    end
  end

  resources :qgroups do
    get :new_group, :on => :member
    get :delete_group, :on => :member
    member do
      put :update_text
    end
  end  

  resources :quotes do
    get :accept, :on => :member
    get :reject, :on => :member 
    get :print, :on => :member
  end

  resources :quotecontents, :only => [:show]

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
 
  resources :products do 
    get :item_options, :on => :member 
    get :cat_item_options, :on => :member 
    get :print, :on => :member
  end
  
  resources :services do 
    get :item_options, :on => :member 
    get :cat_item_options, :on => :member 
    get :print, :on => :member
  end

  resources :miscs do 
    get :item_options, :on => :member 
    get :cat_item_options, :on => :member 
    get :print, :on => :member
  end
  
  resources :productcategories do
    get :cat_options, :on => :member 
  end

  resources :services
  resources :servicecategories

  resources :rates
  resources :ratecategories

  resources :miscs
  resources :misccategories

  resources :mileages do
    get :add_to_expenses, :on => :member  
    get :print, :on => :member
  end

  resources :mileagemodes, :only => [:edit, :update]

  resources :suppliers do
    get :print, :on => :member
  end

  resources :customers do
    get :print, :on => :member
  end

  resources :projects do
    get :print, :on => :member
  end
  
end
