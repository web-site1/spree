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
@properties_hash.merge!(type: [@type_prop,"item_type"] )


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
@bow_option_hash

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


    if !(previous_page.strip == cur_page.strip)
      # if we are here we have to create a product.
      # if the page ends with *-description.* we have an item with varients
      # otherwise we have just a product.
      if !( cur_page =~ /^.*-description\..*/i)
        # standalone product
        stand_alone_product = true
      end

      item_type = item_type(rcpbs)

      # find taxon record
      srchtype = (item_type.blank?) ? item_type.strip:%Q{#{item_type.downcase.strip}s}
      maincat = get_formed_cat_name(wi.cat)
      subcat = wi.subcat.downcase.strip.titlecase

      perma_srch = %Q{'%#{srchtype}%#{maincat}%#{subcat}%'}

      taxonrec = Spree::Taxon.where("permalink like #{perma_srch} ")
      #
      @product = Spree::Product.find_by_name(wi.title)
      if !@product.nil?
        logger.info "Product #{wi.title} exsists in Spree"
        puts "Product #{wi.title} exsists in Spree"
      else
        @product = Spree::Product.new(
          name: wi.title.strip.titlecase,
          description:wi,top_description,
          available_on: Date.today(),
          shipping_category_id: 1 ,
          meta_keywords: wi.keywords,
          price: rcpbs.price.to_f
        )


        #create taxon for product
        if !taxonrec.nil?
          @product << taxonrec
          @product.save
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
            propval.update_attribute(value: eval(v.last) )
          end
        end


        logger.info "Product #{wi.title} created in Spree"
        puts "Product #{wi.title} created in Spree"

        # create Master Variant

      end
    end




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