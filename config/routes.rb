Rails.application.routes.draw do
  root 'onlinelending#registerindex'

  get '/onlinelending/registerindex'

  get '/onlinelending/loginindex'

  post '/onlinelending/register'

  post '/onlinelending/login'

  get '/onlinelending/borrowerindex'

  get '/onlinelending/lenderindex'

  get '/logout' => "onlinelending#logout"

  post '/lend' => "onlinelending#lend"


  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products
end
