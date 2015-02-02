# create Items -
# - creates Items and associated records from Web item file
#
# Run from scripts directory  ruby

require '../config/environment'

log_file_name = %Q{Item_create-#{Time.now.strftime("%m%d%y%I%M")}.log}
log_file =  %Q{#{Rails.root}/log/#{log_file_name}}
logger = Logger.new(log_file)
logger.info "Starting to create Items"
puts "Starting to create Items"

# create and gather the needed properties for main item

products_created = 0
variants_created = 0
error_items = 0

@local_site_path = "/home/louie/Dropbox/DEV/Artistic/sitesucker/www.artisticribbon.com/"


# Properties
@properties_hash = {}
# color
@color_prop = Spree::Property.find_by_name('color')
if @color_prop.nil?
  @color_prop = Spree::Property.create(
      name: "Color",
      presentation: "Color"
  )
end
@properties_hash.merge!(color: [@color_prop,"rcpbs.ws_color"] )
# type
@type_prop = Spree::Property.find_by_name('type')
if @type_prop.nil?
  @type_prop = Spree::Property.create(
      name: "Type",
      presentation: "Type"
  )
end
@properties_hash.merge!(type: [@type_prop,"@item_type"] )


# Brand
@brand_prop = Spree::Property.find_by_name('brand')
if @brand_prop.nil?
  @brand_prop = Spree::Property.create(
      name: "Brand",
      presentation: "Brand"
  )
end

@properties_hash.merge!(brand: [@brand_prop,"rcpbs.brand"] )
# ----------------------------------------------------------------------
# options

#Ribbon Options
@ribbon_option_hash = {}
ribbon_width_option = Spree::OptionType.find_by_name('ribbon-width')
if ribbon_width_option.nil?
  ribbon_width_option = Spree::OptionType.create(
      name: 'ribbon-width',
      presentation: 'Width'
  )
end
@ribbon_option_hash.merge!(width: ribbon_width_option)

ribbon_putup_option = Spree::OptionType.find_by_name('ribbon-putup')
if ribbon_putup_option.nil?
  ribbon_putup_option = Spree::OptionType.create(
      name: 'ribbon-putup',
      presentation: 'Putup'
  )
end
@ribbon_option_hash.merge!(putup: ribbon_putup_option)


#Bow Options
@bow_option_hash = {}

bow_size_option = Spree::OptionType.find_by_name('bow-size')
if bow_size_option.nil?
  bow_size_option = Spree::OptionType.create(
      name: 'bow-size',
      presentation: 'Size'
  )
end
@bow_option_hash.merge!(size: bow_size_option)
@bow_option_hash.merge!(putup: ribbon_putup_option)

sorted_web_items =

previous_page = " "

@position = 1

WebItem.all.order(:page).all.each do |wi|

    cur_page = wi.page
    stand_alone_product = false

    #check for link to rc_pbs table if none log error and skip
    rcpbs = RcPbs.find_by_item(wi.item)
    if rcpbs.nil?
      logger.info "Item #{wi.item} not found in Rc_pbs table"
      puts "Item #{wi.item} not found in Rc_pbs table"
      error_items += 1
      next
    end

    is_master = false

    if !(previous_page.strip == cur_page.strip)
      # if we are here we have to create a product.
      # if the page ends with *-description.* we have an item with varients
      # otherwise we have just a product.
      if !( cur_page =~ /^.*-description\..*/i)
        # standalone product
        stand_alone_product = true
      end

      is_master = true
      @position = 1

      @item_type = item_type(rcpbs) ||  ''

      # find taxon record
      srchtype = (@item_type.blank?) ? @item_type.strip : %Q{#{@item_type.downcase.strip}s}
      maincat = get_formed_cat_name(wi.cat)
      subcat = wi.subcat.downcase.strip.titlecase

      perma_srch = %Q{'%#{srchtype}%#{maincat}%#{subcat}%'}

      taxonrec = Spree::Taxon.where("permalink like #{perma_srch} ").first
      #
      @product = Spree::Product.find_by_name(wi.title)
      if !@product.nil?
        logger.info "Product #{wi.title} exsists in Spree"
        puts "Product #{wi.title} exsists in Spree"
      else
        @product = Spree::Product.new(
          name: wi.title.strip.titlecase,
          description: wi.top_description,
          available_on: Date.today()-1.day,
          shipping_category_id: 1 ,
          meta_keywords: wi.keywords,
          price: rcpbs.rc_price.to_f,
          sku: rcpbs.new_pbs_desc_1
        )


        @product.save!
        #create taxon for product
        existing_taxon_array = @product.taxons.map{|t| t.id}
        if !taxonrec.nil? && !existing_taxon_array.include?(taxonrec.id)
          @product.taxons << taxonrec
          @product.save!
        end



        array_of_properties = @product.properties.map{|p| p.name}

        @properties_hash.each do |k,v|


          if !array_of_properties.include?(v.first.name)
            @product.properties << v.first
            @product.save!
          end

          propval = Spree::ProductProperty.find_by_product_id_and_property_id(
            @product.id,v.first.id
          )
          if propval.nil?
            propval = Spree::ProductProperty.create(
                product_id:@product.id,
                property_id: v.first.id,
                value: eval(v.last)
            )
          else
            propval.update_attribute(:value, eval(v.last) )
          end
        end

        array_of_options = @product.option_types.map{|ot|ot.name}

        option_hash = {}

        if @item_type == "Ribbon"
          option_hash = @ribbon_option_hash
        elsif @item_type == "Bow"
          option_hash = @bow_option_hash
        end

        option_hash.each do |k,v|

          if !array_of_options.include?(v.name)
            @product.option_types << v
            @product.save!
          end

          opval = Spree::ProductOptionType.find_by_product_id_and_option_type_id(
              @product.id,v.id
          )
          if opval.nil?
            opval = Spree::ProductOptionType.create(
                product_id:@product.id,
                option_type_id: v.id
            )
          end
        end

        #create product image
        image_path = %Q{#{@local_site_path}#{wi.image_file[/images.*/i,0]}}
        if File.exists?(image_path)
          @product.images <<  Spree::Image.create!(:attachment => File.open(image_path))
          @product.save!
        end

        logger.info "Product #{wi.title} created in Spree"
        puts "Product #{wi.title} created in Spree"
      end
    else
      @position += 1
      # create Variant
      v = Spree::Variant.new(
          sku: rcpbs.new_pbs_desc_1,
          product_id: @product.id,
          is_master: is_master,
          price: rcpbs.rc_price,
          cost_currency: "USD",
          track_inventory: true,
          tax_category_id: 1,
          stock_items_count: 1
      )
      v.save!

      # set options
      ot = v.product.option_types
      if !ot.empty?
        array_of_type_and_id = ot.map{|o|[o.id,o.name]}

        array_of_type_and_id.each do |av|
          val = ''
          srcval = ''
          if av.last == "ribbon-width"
            val = rcpbs.width
            srcval = val
          elsif av.last == "ribbon-putup"
            val = rcpbs.putup_pack
            srcval = val.strip.gsub(' ','-')
          else
            val = rcpbs.new_pbs_desc_3.split(",").last.strip.titlecase rescue ''
            srcval = val
          end

          if !val.empty?
            sov = Spree::OptionValue.find_by_option_type_id_and_name(
                av.first,srcval
            )
            if sov.nil?
              sov = Spree::OptionValue.create(
                  option_type_id: av.first,
                  presentation: val,
                  name: srcval
              )
            end
            v.option_values << sov
            v.save!
          end
        end

      end
      #create product image
      image_path = %Q{#{@local_site_path}#{wi.image_file[/images.*/i,0]}}
      if File.exists?(image_path)
        v.images <<  Spree::Image.create!(:attachment => File.open(image_path))
        v.save!
      end

    end



    logger.info "Variant #{rcpbs.new_pbs_desc_1} created in Spree"
    puts "Variant #{rcpbs.new_pbs_desc_1} created in Spree"

    previous_page = cur_page.strip
end





BEGIN{
  def item_type(pbs_item_rec)
    itemtype = ''
    case
      when pbs_item_rec.ws_cat =~ /ribbon/i
        itemtype = "Ribbon"
      when pbs_item_rec.ws_cat =~ /bow/i
        itemtype =  "Bow"
    end
  end

  def get_formed_cat_name(webcat)
    webcat.cat.downcase.gsub('ribbon','').gsub('bows','').strip.titlecase rescue ''
  end

  def get_master_sku(sku)
    t = sku.split('-')
    %Q{#{t[0]}-#{t[1]}}
  end



}