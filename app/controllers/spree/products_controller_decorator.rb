Spree::ProductsController.class_eval do

  def show_new_arrivals
    @quick_title = "New Arrivals"
    @products = Spree::Product.where("available_on <= ?",Date.today).order(available_on: :desc).limit(10)
    render :template => 'spree/products/quick_results'
  end

  def show
	  if request.format == 'html'
		  @variants = @product.variants_including_master.active(current_currency).includes([:option_values, :images])
		  @product_properties = @product.product_properties.includes(:property)
		  @taxon = Spree::Taxon.find(params[:taxon_id]) if params[:taxon_id]
		  @taxon ||= @product.taxons.first
		elsif request.format == 'json'
			if @product.colors.uniq.length > 1
				@products = [@product]
			else
				@taxon = Spree::Taxon.find(params[:taxon_id]) if params[:taxon_id]
				@taxon ||= @product.taxons.first
				@products = @taxon.products.includes(:master, :variants => [{:option_values => :option_type}, :images, :prices],:product_properties => :property, :product_option_types => :option_type)
				# render :text => @products.count
			end
		end
	end

	def related_products
		load_product
		@taxon = Spree::Taxon.find(params[:taxon_id]) if params[:taxon_id]
		@taxon ||= @product.taxons.first
		@related_products = []#@taxon.products	
		# render :json => [ {name:"product #{rand(100)}",image:@product.images.first.attachment.url(:product), url:"/products/#{@product.slug}"}, {name:"product #{rand(100)}",image:@product.images.first.attachment.url(:product), url:"/products/#{@product.slug}"}, {name:"product #{rand(100)}",image:@product.images.first.attachment.url(:product), url:"/products/#{@product.slug}"}, {name:"product #{rand(100)}",image:@product.images.first.attachment.url(:product), url:"/products/#{@product.slug}"}].to_json
	end

end