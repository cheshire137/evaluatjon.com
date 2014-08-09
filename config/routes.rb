Rails.application.routes.draw do
  scope '/api' do
    devise_for :users, controllers: {registrations: 'registrations',
                                     sessions: 'sessions'}

    resources :ratings, except: [:new, :edit]
  end
end
