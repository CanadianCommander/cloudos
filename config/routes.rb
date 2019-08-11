Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: redirect("/dashboard")

  namespace :dashboard do
    get '/', to: 'home#dashboard'
  end

  # system api
  namespace :api do
    get '/system/programs/list', to: 'system/program#listPrograms'
    scope '/system/program/:id' do
      get '/info', to: 'system/program#getProgramInfo'
    end
  end

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
end
