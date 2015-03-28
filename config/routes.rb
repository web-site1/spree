Rails.application.routes.draw do

  # This line mounts Spree's routes at the root of your application.
  # This means, any requests to URLs such as /products, will go to Spree::ProductsController.
  # If you would like to change where this engine is mounted, simply change the :at option to something different.
  #
  # We ask that you don't use the :as option here, as Spree relies on it being the default of "spree"
  mount Spree::Core::Engine, :at => '/'
          # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # Take care of exceptions
  get '/1-grosgrain-prints-ribbon-category', to: redirect('/t/categories/ribbons/grosgrain/grosgrain-prints')
  get '/1-velvet-grosgrain-ribbon-category', to: redirect('t/categories/ribbons/velvet/velvet-grosgrain')
  get '/1-:subcat-grosgrain-ribbon-category', to: redirect('/t/categories/ribbons/grosgrain/%{subcat}-grosgrain')

  get '/1-dotted-ribbon-category', to: redirect('/t/categories/ribbons/dot-ribbon')
  get '/1-:subcat-velvet-ribbon-category', to: redirect('/t/categories/ribbons/velvet/%{subcat}-velvet')
  get '/eurototes-:subcat', to: redirect('/t/categories/eurototes/%{subcat}')
  get '/eurototes', to: redirect('/t/categories/eurototes')

  # Redirect correctly formatted sub category ribbon requests to new url
  # This works for correctly formatted URLs:  /1-subcat-cat-ribbon-category.htm

  get '/1-:subcat-:cat-ribbon-category', to: redirect('/t/categories/ribbons/%{cat}/%{subcat}')

  # Redirect correctly formatted CATEGORY  pages:
  get '1-:cat-ribbon-category', to: redirect('/t/categories/ribbons/%{cat}-ribbon')

  # Tulle & Trims
  get '1-:cat-category', to: redirect('/t/categories/%{cat}')

  # Redirect all old product requests to new url
  # #Ex: Old: /1-venetian-blue-nyvalour-velvet-ribbon-description.htm
  #      New: /products/venetian-blue-nyvalour-velvet-ribbon
  get '/1-:product-description', to: redirect('/products/%{product}')


  # get '1-:prod-description', to: redirect  { |path_params|
  #         Rails.logger.debug "!!! /products/#{path_params[:prod]}"
  #         "/products/#{path_params[:prod]}"
  #       }

  # get '/1-black-stitches-grosgrain-ribbon-description', to: redirect { |path_params|
  #                                                       Rails.logger.debug "!!! /products/eatme"
  #                                                       '/products/black-stitches-grosgrain-ribbon'
  #                                                     }
  # get '1-*anything', :to => redirect  { |path_params|
  #                  Rails.logger.debug "!!! /1-*product-description #{path_params.inspect}"
  #                  "#{path_params[:anything]}"
  #                }

end
