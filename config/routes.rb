Rails.application.routes.draw do
  devise_for :users

  scope '/api' do
    resources :ratings, except: [:new, :edit]
  end
end
