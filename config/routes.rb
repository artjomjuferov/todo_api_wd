Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :tasks do
        put :tag, on: :member
      end
    end
  end
end
