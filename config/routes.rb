Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post 'auth/register', to: 'auth#register'
      post 'auth/login',    to: 'auth#login'
      get  'auth/me',       to: 'auth#me'
      resources :resumes, only: [:index, :create]
    end
  end
end
