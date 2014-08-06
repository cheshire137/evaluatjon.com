Rails.application.routes.draw do
  scope '/api' do
    resources :ratings, except: [:new, :edit]
  end
end
