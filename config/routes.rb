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
    get '/system/programs/list', to: 'system/program#list_programs'
    scope '/system/program/:id' do
      get '/', to: 'system/program#get_program_info'
      get '/containers', to: 'system/program#get_containers'
      put '/fork', to: 'system/program#fork_program'
      put '/kill', to: 'system/program#kill_program'
    end

    scope '/system/program/install' do
      post '/git', to: 'system/program#install_program_from_git'
    end

    scope '/system/containers/' do
      get '/list', to: 'system/container#list_containers'
    end

    scope '/system/container/:id' do
      get '/', to: 'system/container#get_container'
      put '/suspend', to: 'system/container#suspend_container'
      put '/resume', to: 'system/container#resume_container'
      delete '/destroy', to: 'system/container#destroy_container'
    end
  end

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
end
