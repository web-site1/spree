Spree::ProductsController.class_eval do

  def show_new_arrivals
    @quick_title = "New Arrivals"
    @products = Spree::Product.where("available_on <= ?",Date.today).order(available_on: :desc).limit(10)
    render :template => 'spree/products/quick_results'
  end

  def show_new_flower_arrivals
    @quick_title = "New Flowers"
    all_flowers = []
    @flower_taxon = Spree::Taxon.find_by_name('flowers')
    @flower_taxon.children.each{|c|
      c.products.each{|p| all_flowers << p}
    }
    all_flowers.sort!{|a,b| b[:available_on] <=> a[:available_on] rescue []}
    @products = all_flowers[0..9]
    #@products = Spree::Product.where("available_on <= ?",Date.today).order(available_on: :desc).limit(10)
    render :template => 'spree/products/quick_results'
  end


  def show
    # Do not async load javascript for this page.
    @async = false
  	# select correct taxon
  	if params[:taxon_id]
	  	@taxon = Spree::Taxon.find(params[:taxon_id]) 
		elsif @product.taxons.length == 1
			@taxon = @product.taxons.first
	  else
			@taxon = @product.taxons.first
	  	taxon_names = @product.taxons.collect &:name
	  	for i in 0 .. taxon_names.length-1
	  		if(@product.name[taxon_names[i]])
	  			@taxon = @product.taxons[i]
	  			break;
	  		end
	  	end
	  end

	  if request.format == 'html'
		  @variants = @product.variants_including_master.active(current_currency).includes([:option_values, :images])
		  @product_properties = @product.product_properties.includes(:property)
		elsif request.format == 'json'
			if @product.colors.uniq.length > 1
				@products = [@product]
			else
				@taxon = Spree::Taxon.find(params[:taxon_id]) if params[:taxon_id]
				@products = @taxon.products.includes(:master, :variants => [{:option_values => :option_type}, :images, :prices],:product_properties => :property, :product_option_types => :option_type)
				# render :text => @products.count
			end
		end
	end

	def related_products
		load_product
		@taxon = Spree::Taxon.find(params[:taxon_id]) if params[:taxon_id]
		@taxon ||= @product.taxons.first
		if((@taxon.parent.name.downcase rescue '')['accessories'])
			@related_products = @taxon.products - [@product]
		else
			@related_products = []
			@taxon.parent.children.each do |child|
				@related_products << child.products.first if child.products.first and child.products.first != @product
			end	
			@related_products = @related_products.select{|p| !p.images.first.nil? }
		end
		

		# render :json => [ {name:"product #{rand(100)}",image:@product.images.first.attachment.url(:product), url:"/products/#{@product.slug}"}, {name:"product #{rand(100)}",image:@product.images.first.attachment.url(:product), url:"/products/#{@product.slug}"}, {name:"product #{rand(100)}",image:@product.images.first.attachment.url(:product), url:"/products/#{@product.slug}"}, {name:"product #{rand(100)}",image:@product.images.first.attachment.url(:product), url:"/products/#{@product.slug}"}].to_json
	end

end