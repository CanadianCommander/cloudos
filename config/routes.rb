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

    end

    scope '/system/program/install' do
      post '/git', to: 'system/program#install_program_from_git'
    end
  end

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
end
