Rails.application.routes.draw do
  constraints DomainConstraint.new('localhost', 'alpha', 'beta', 'discoverone') do
    # constraints DomainConstraint.new('alpha') do

    root to: 'service#index'

    get '/login' => 'service/users#login'
    post '/login' => 'service/users#login_user'

    get '/landing_signup' => 'service/users#landing_signup'
    get '/signup' => 'service/users#signup'
    get '/users/me' => 'service/users#me'

    resources :users, module: 'service' do
    end

    resources :orders, only: [:create, :show], module: 'service' do
      collection do
         get :plans
        get :done
      end

      member do
        put :complete
      end
    end

    resources :inquiries, only: [:index], module: 'service' do
    end

    resources :apply, only: [:index, :show], module: 'service' do
      collection do
        get :tradingapply
        get :communitysolarapply
        get :essshareapply
        get :smallscalepowerapply
      end
    end

    resources :information, only: [:index, :show, :show], module: 'service' do
      collection do
        get :tradinginfo
        get :communitysolarinfo
        get :essshareinfo
        get :smallscalepowerinfo
        get :infomonitor
        get :infouse
        get :infopower
        get :infopayment
        get :infoenergy
        get :infodr
        get :infosettle
        get :infosetting
      end
    end

    resources :inforshare, only: [:index], module: 'service' do
      collection do
        get :shareinfo
        get :sharefail
        get :sharehyst
        get :sharemonitor
        get :sharepower
        get :shareservice
        get :sharesetting
        get :sharesettle

      end
    end

    resources :inforcommunity, only: [:index], module: 'service' do
      collection do
        get :communitysolarinfo
        get :communityrec
        get :communitypay
        get :communitynot
        get :communitymonitor
        get :communitycus
      end
    end

    resources :infortrade, only: [:index], module: 'service' do
      collection do
        get :infortradedash
        get :infortrademonitor
        get :infortradeplant
        get :infortradetra
        get :infortradecus
        get :infortradenot
      end
    end

    resources :summary, only: [:index, :show], module: 'service' do
      collection do
        get :communitysolar
        get :trading
        get :essshare
        get :smallscalepower
      end
    end





    resources :customerserv, only: [:index], module: 'service' do
      collection do
        get :tradingcus
        get :communitysolarcus
        get :esssharecus
        get :smallscalepowercus
      end



    end

    match '*path', to: "service#index", via: :all
  end
end
