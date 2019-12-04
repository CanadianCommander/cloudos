Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: redirect("/dashboard")

  namespace :dashboard do
    get '/', to: 'home#dashboard'
  end

  # system api
  namespace :api do

    namespace :auth do
      get '/token', to: 'api_auth#get_api_token'
    end

    get '/system/programs/list', to: 'system/program#list_programs'
    scope '/system/program/:id' do
      get '/', to: 'system/program#get_program_info'
      get '/containers', to: 'system/program#get_containers'
      put '/fork', to: 'system/program#fork_program'
      put '/kill', to: 'system/program#kill_program'
      delete '/', to: 'system/program#delete_program'
    end

    scope '/system/program/install' do
      post '/git', to: 'system/program#install_program_from_git'
    end

    scope '/system/containers/' do
      get '/list', to: 'system/container#list_containers'
    end

    scope '/system/container/:id' do
      get '/', to: 'system/container#get_container'
      get '/proxies', to: 'system/container#get_container_proxies'
      put '/suspend', to: 'system/container#suspend_container'
      put '/resume', to: 'system/container#resume_container'
      delete '/', to: 'system/container#destroy_container'
    end

    scope '/system/proxy/:id' do
      get '/', to: 'system/proxy#get_proxy'
      get '/container', to: 'system/proxy#get_proxy_container'
      put '/', to: 'system/proxy#update_proxy'
      delete '/', to: 'system/proxy#destroy_proxy'
    end

    scope '/system/proxies/' do
      get '/list', to: 'system/proxy#list_proxies'
    end

    scope '/system/proxy' do
      post '/', to: 'system/proxy#create_proxy'
      post '/container', to: 'system/proxy#create_container_proxy'
    end

  end

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
end
