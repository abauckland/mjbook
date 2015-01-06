Mjbook::Engine.routes.draw do
  
  resources :participants

  resources :donations

  resources :donors

  resources :writeoffs, :only => [:index, :show, :create, :destroy]

  resources :creditnotes, :only => [:index, :show, :create, :destroy] do
    get :email, :on => :member 
  end

  resources :miscexpenses

  resources :transfers, :only => [:index, :edit, :new, :create, :update, :destroy] do
    get :process_transfer, :on => :member
  end

  resources :companyaccounts, :only => [:index, :edit, :new, :create, :update, :destroy]

  resources :salaries do
    get :accept, :on => :member
    get :reject, :on => :member 

    get :transfer, :on => :member
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
    get :email, :on => :member
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
    get :email, :on => :member 
    get :accept, :on => :member
    get :reject, :on => :member
    get :print, :on => :member
  end

  resources :quotecontents, :only => [:show]

  resources :summaries, :only => [:index] do
    get :charts, :on => :member
  end

  resources :expenses do 
    get :accept, :on => :member
    get :reject, :on => :member 

    get :pay, :on => :member
  end
  
  resources :personals

  resources :employees, :only => [:index, :show] 

  resources :businesses

  resources :expends do
    get :pay_employee, :on => :member
    get :pay_business, :on => :member
    get :pay_salary, :on => :member
    
    get :reconcile, :on => :member
    get :unreconcile, :on => :member
  end

  resources :processinvoices, :only => [:index, :new] do
    get :payment, :on => :member
    get :creditnote, :on => :member  
    get :writeoff, :on => :member  
  end

  resources :payments do
    get :email, :on => :member 
    get :reconcile, :on => :member  
    get :unreconcile, :on => :member
  end

 
  resources :products do 
    get :quote_item_options, :on => :member 
    get :invoice_item_options, :on => :member 
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
