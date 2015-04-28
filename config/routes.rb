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

  get 'products/:id/related_products' => 'spree/products#related_products'
  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  get '/ajax_cart' => 'spree/orders#ajax_cart'

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
  get 'grosgrain_ribbon', to: redirect('t/categories/ribbons/grosgrain')

  get '/1-dotted-ribbon-category', to: redirect('/t/categories/ribbons/dot-ribbon')
  get '/1-:subcat-velvet-ribbon-category', to: redirect('/t/categories/ribbons/velvet/%{subcat}-velvet')
  get 'Velvet', to: redirect('/t/categories/ribbons/velvet')
  get 'crushed_velvet_ribbon', to: redirect('/t/categories/ribbons/velvet/crushed-velvet')

  get '/eurototes-:subcat', to: redirect('/t/categories/eurototes/%{subcat}')
  get '/eurototes', to: redirect('/t/categories/eurototes')

  get '/1-cord-on-a-spool-category', to: redirect('/t/categories/tulle-and-trims/cord-on-a-spool')
  get '/1-stretch-loops-category', to: redirect('/t/categories/tulle-and-trims/stretch-loops')
  get '/1-tulle-category', to: redirect('/t/categories/tulle-and-trims/tulle')
  get '/1-sparkle-tulle-category', to: redirect('/t/categories/tulle-and-trims/sparkle-tulle')
  get '/1-dotted-tulle-category', to: redirect('/t/categories/tulle-and-trims/dotted-tulle')
  get '/1-jeannie-tulle-category', to: redirect('/t/categories/tulle-and-trims/jeannie-tulle')
  get '/1-lacey-category', to: redirect('/t/categories/tulle-and-trims/lacey')
  get '/1-jute-cord-category', to: redirect('/t/categories/tulle-and-trims/jute-cord')
  get '/1-geomesh-category', to: redirect('/t/categories/tulle-and-trims/geomesh')
  get '/1-geomesh-cross-category', to: redirect('/t/categories/tulle-and-trims/geomesh-cross')
  get '/1-giltter-maze-category', to: redirect('/t/categories/tulle-and-trims/giltter-maze')
  get '/1-love-foiled-category', to: redirect('/t/categories/tulle-and-trims/love-foiled')
  get '/1-jasmine-category', to: redirect('/t/categories/tulle-and-trims/jasmine')
  get '1-newest-ribbon-category.htm', to: redirect('/show_new_arrivals')
  get '1-MLB-ribbon-category', to: redirect('/t/categories/sports/MLB-ribbon')
  get '1-:team-MLB-ribbon', to: redirect('/t/categories/sports/MLB-ribbon/%{team}')
  get 'NFL-licensed-ribbon-:team', to: redirect('/t/categories/sports/NFL-licensed-ribbon/%{team}')
  get 'CLC-licensed-ribbon-:team', to: redirect('/t/categories/sports/CLC-licensed-ribbon/%{team}')
  get '1-:team-ribbon-1', to: redirect('/t/categories/sports/MLB-ribbon/%{team}')
  get '1-:team-ribbon-2', to: redirect('/t/categories/sports/MLB-ribbon/%{team}')
  get '1-:team-ribbon-3', to: redirect('/t/categories/sports/MLB-ribbon/%{team}')
  get '1-:team-ribbon-4', to: redirect('/t/categories/sports/MLB-ribbon/%{team}')



  get '1-plaid-ribbon-category', to: redirect('/t/categories/ribbons/check-and-plaid')
  get 'about_artistic_ribbon', to: redirect('/why_shop/about_us')
  get 'flowers-huge', to: redirect('/t/categories/flowers/4-4-dot-5-inches')
  get 'paisley-punch-collection', to: redirect('/products/euro-totes-paisley-punch-collection')
  get 'personalized_ribbon', to: redirect('/why_shop/custom')
  get 'Flowers:num', to: redirect('/t/categories/flowers')
  get 'flowers', to: redirect('/t/categories/flowers')
  get 'new-flowers:foo', to: redirect('/products?for_new_flowers=true')
  get 'artificial_dry_flowers:foo', to: redirect('/t/categories/flowers')
  get ':foo_flowers_:bar', to: redirect('/t/categories/flowers')
  get 'happy-mothers-day-ribbon', to: redirect('/t/categories/ribbons/celebration/happy-mothers-day')

  # Redirect correctly formatted sub category ribbon requests to new url
  # This works for correctly formatted URLs:  /1-subcat-cat-ribbon-category.htm

  get '/1-:subcat-:cat-ribbon-category', to: redirect('/t/categories/ribbons/%{cat}/%{subcat}')

  # Redirect correctly formatted CATEGORY  pages:
  get '1-:cat-ribbon-category', to: redirect('/t/categories/ribbons/%{cat}')

  # Tulle & Trims
  get '1-:cat-category', to: redirect('/t/categories/%{cat}')

  # Redirect all old product requests to new url
  # #Ex: Old: /1-venetian-blue-nyvalour-velvet-ribbon-description.htm
  #      New: /products/venetian-blue-nyvalour-velvet-ribbon
  get '/1-:product-description', to: redirect('/products/%{product}')

  get 'show_new_arrivals' => 'spree/products#show_new_arrivals'
  get 'show_new_flowers' => 'spree/products#show_new_flower_arrivals'
  get 'why_shop/:id' => 'spree/home#why_shop'
  get 'site/:id' => 'spree/home#why_shop'
  post 'change_art_state' => 'spree/orders#change_art_state'
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
