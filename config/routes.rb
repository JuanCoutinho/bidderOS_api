Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post 'auth/register', to: 'auth#register'
      post 'auth/login',    to: 'auth#login'
      get  'auth/me',       to: 'auth#me'
      resources :resumes, only: [:index, :create]
      post 'recommendations', to: 'recommendations#index'
      post 'recommendations/cover_letter', to: 'recommendations#generate_cover_letter'
    end
  end
end
