MyHours::Application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'login#signup'

  get '/login/change_password_from_email/:guid', to: 'login#change_password_from_email', as: 'password_change' 

  post ':controller(/:action(/:id(.:format)))'
  get ':controller(/:action(/:id(.:format)))'
  mount API::API => '/'
end
