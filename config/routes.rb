Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  resources :schedule_types
  resources :promotions
  resources :configs
  resources :referrals
  resources :expirations
  resources :venues, except: [:new, :edit]
  resources :distributions do
    collection do
      get 'by_room_id'
    end
  end
  resources :schedules do
    member do
      get 'bookings'
    end
    collection do
      get 'weekly_scope'
    end
  end
  resources :rooms, except: [:new, :edit]
  resources :instructors, except: [:new, :edit]
  resources :appointments do
    collection do
      match 'book', :to => "appointments#book", :via => [:post, :options]
      get 'weekly_scope_for_user', :to => 'appointments#weekly_scope_for_user'
      get 'historic_for_user', :to => 'appointments#historic_for_user'
    end
    member do
      get 'cancel', :to => "appointments#cancel"
      match 'edit_station_number', :to => "appointments#edit_station_number", :via => [:post, :options]
    end
  end
  resources :emails, except: [:new, :edit]
  resources :cards do 
    collection do
      match 'register_for_user', :to => 'cards#register_for_user', :via => [:post, :options]
      match 'delete_for_user', :to => 'cards#delete_for_user', :via => [:post, :options]
      match 'set_primary_for_user', :to => 'cards#set_primary_for_user', :via => [:post, :options]
      get 'get_primary_for_user', :to => 'cards#get_primary_for_user'
      get 'get_all_for_user', :to => 'cards#get_all_for_user'
    end
  end

  resources :packs, except: [:new, :edit]
  resources :purchases do
    collection do
      match 'charge', :to => "purchases#charge", :via => [:post, :options]
    end
  end
  
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self) rescue ActiveAdmin::DatabaseHitDuringLoad
  
  mount_devise_token_auth_for 'User', at: 'auth', :controllers => {:registrations => "registrations", :sessions => "sessions", :passwords => "passwords"}, defaults: { format: :json }#, :skip => [:registrations]

  devise_scope :user do
    match 'users/sign_up', :to => "registrations#create", :via => [:post, :options]
    match 'users/sign_in', :to => "sessions#create", :via => [:post, :options]
    match 'users/password', :to => "passwords#create", :via => [:post, :options]
    get 'logout', :to => "sessions#destroy"
    get 'session', :to => "sessions#get"
  end
  
  resources :users do
    member do
      match 'send_coupon_by_email', :to => "users#send_coupon_by_email", :via => [:post, :options]
    end
  end

  resources :roles, except: [:new, :edit]
    
  match 'discounts/validate_with_coupon', :to => "discounts#validate_with_coupon", :via => [:post, :options]
  match 'discounts/validate_with_credits', :to => "discounts#validate_with_credits", :via => [:post, :options]
  
  root to: "admin/dashboard#index"
  
end
