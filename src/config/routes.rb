Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  resources :patients do
    member do
      post :bmr
      get :bmr_history
    end
  end

  resources :doctors

  post :bmi, to: 'calculations#bmi'

  # Health check
  get '/health', to: proc { [200, {}, ['{"status":"ok"}']] }
end
