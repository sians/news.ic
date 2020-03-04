Rails.application.routes.draw do
  # get 'articles/index'
  devise_for :users
  root to: 'pages#home'
  resources :articles

  get 'articles/scrape', to: 'articles#scrape_articles', as: 'scrape_articles'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
