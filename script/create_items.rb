# create Items -
# - creates Items and associated records from Web item file
#
# Run from scripts directory  ruby


require File.expand_path('../../config/environment', __FILE__)
#require '../config/environment'
require 'csv'
#local run code

=begin
Spree::Product.where('id > 23').delete_all
Spree::Variant.where('id > 51').delete_all
Spree::ProductProperty.where('id > 17').delete_all
Spree::Asset.where('id > 6').delete_all
Spree::Price.delete_all
Spree::ProductTaxon.delete_all
Spree::spree_option_values.delete_all
spree_option_values_variants
=end


log_file_name = %Q{Item_create-#{Time.now.strftime("%m%d%y%I%M")}.log}
log_file =  %Q{#{Rails.root}/log/#{log_file_name}}
logger = Logger.new(log_file)
logger.info "Starting to create Items"
puts "Starting to create Items"
puts Spree::Image.attachment_definitions[:attachment].inspect

csv_error_file =  %Q{#{Rails.root}/log/item_import_errors.csv}



# create and gather the needed properties for main item

@products_created = 0
@variants_created = 0
@error_items = 0


#@local_site_path = "/Users/dsadaka/Dropbox/DEV/Artistic/sitesucker/www.artisticribbon.com/"
if Rails.env == 'staging'
  @local_site_path =   "/var/www/artspree3/"
else
  @local_site_path = "/home/louie/Dropbox/DEV/Artistic/sitesucker/www.artisticribbon.com/"
end

puts "Local image directory is #{@local_site_path}"
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

all_color_option = Spree::OptionType.find_by_name('color')
if all_color_option.nil?
  all_color_option = Spree::OptionType.create(
      name: 'color',
      presentation: 'Color'
  )
end



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
@ribbon_option_hash.merge!(color: all_color_option)


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
@bow_option_hash.merge!(color: all_color_option)



#Flower Options
@flower_option_hash = {}
flower_width_option = Spree::OptionType.find_by_name('width')

if flower_width_option.nil?
  flower_width_option = Spree::OptionType.create(
      name: 'width',
      presentation: 'Width'
  )
end

@flower_option_hash.merge!(width: flower_width_option)
@flower_option_hash.merge!(color: all_color_option)

=begin


flower_color_option = Spree::OptionType.find_by_name('color')

if flower_color_option.nil?
  flower_color_option = Spree::OptionType.create(
      name: 'color',
      presentation: 'Color'
  )
end

@flower_option_hash.merge!(color: flower_color_option)
=end




sorted_web_items =

previous_page = " "

@position = 1


CSV.open(csv_error_file, "wb") do |csv|
  csv << ['rcpbs_id','wi_id','error']

    r = RcPbs.joins( "left JOIN web_items on web_items.item = rc_pbs.item").order('web_items.page').limit(30)
    #r = RcPbs.find(186691,186743,186795,186847,186899,186951,187003)
    r.each do |rcpbs|

      web_item = WebItem.find_by_item(rcpbs.item)
      item_with_multiple_variants = false
      product_created = false

      if !web_item.nil?
        item_with_multiple_variants =  (WebItem.where(page: web_item.page).count > 1)
      end

        begin
          @rcpbs = rcpbs
          @wi = web_item

          @is_master = false

          @position = 1

          @item_type = item_type(rcpbs) ||  ''

          # find taxon record
          srchtype = (@item_type.blank?) ? @item_type.strip : %Q{#{@item_type.downcase.strip}s}
          maincat = get_formed_cat_name(@rcpbs.ws_cat)
          flow_sub = @rcpbs.ws_subcat.downcase.strip.titlecase.gsub('.','')
          subcat = @rcpbs.ws_subcat.downcase.strip.titlecase.gsub(' ','%')

          perma_srch = %Q{'%#{srchtype}%#{maincat}%#{subcat}%'}

          taxonrec = Spree::Taxon.where("permalink like #{perma_srch} ").first
          #


          prod_sku = suggest_sku(@rcpbs,logger,flow_sub,csv)

          if @item_type == 'Flower'
            p_var = Spree::Variant.find_by_sku(flow_sub)
            if p_var
              @product = p_var.product
            else
              @product = nil
            end
          else
            if @wi
              @product = Spree::Product.find_by_name(@wi.title)
              if @product.nil?
                pv =  Spree::Variant.find_by_sku(prod_sku)
                if pv
                  @product = pv.product
                else
                  @product = nil
                end
              end
            end
          end



          if !@product.nil?
            create_variant(rcpbs,@wi,logger)
          else

            if @wi
              p_title = @wi.title.strip.titlecase
              p_des = @wi.top_description
              p_meta = @wi.description
              p_key = @wi.keywords
            else
              p_title = @rcpbs.item
              p_des = @rcpbs.desc
              p_meta = @rcpbs.desc
              p_key = ' '
            end


            @product = Spree::Product.new(
              name: p_title,
              description: p_des,
              available_on: Date.today()-1.day,
              shipping_category_id: 1 ,
              meta_description: p_meta,
              meta_keywords: p_key,
              price: rcpbs.rc_price.to_f,
              sku: prod_sku #rcpbs.item
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

              val =  eval(v.last)
              val = val.strip.titlecase
              if propval.nil?
                propval = Spree::ProductProperty.create(
                    product_id:@product.id,
                    property_id: v.first.id,
                    value: val
                )
              else
                propval.update_attribute(:value, val )
              end
            end

            array_of_options = @product.option_types.map{|ot|ot.name}

            option_hash = {}

            if @item_type == "Ribbon"
              option_hash = @ribbon_option_hash
            elsif @item_type == "Bow"
              option_hash = @bow_option_hash
            elsif @item_type == "Flower"
              option_hash = @flower_option_hash
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

            found_image = false
            if @wi

              begin
                #create swatch image if it exsists
                swatch_image_path = %Q{#{@local_site_path}#{@wi.swatch_image_file[/images.*/i,0]}} rescue ''
                if File.exists?(swatch_image_path) && (!@wi.swatch_image_file.nil? && !@wi.swatch_image_file.blank)
                  @product.images <<  Spree::Image.create!(:attachment => File.open(swatch_image_path))
                  @product.save!
                end
              rescue Exception => e
                puts "#{e.to_s} error loading image rcpbs id #{@rcpbs.id}"
              end


              begin
              #create product image
                image_path = %Q{#{@local_site_path}#{@wi.image_file[/images.*/i,0]}} rescue ''
                if File.exists?(image_path) && (!@wi.image_file.nil? && !@wi.image_file.blank)
                  found_image = true
                  @product.images <<  Spree::Image.create!(:attachment => File.open(image_path))
                  @product.save!
                end
              rescue Exception => e
                puts "#{e.to_s} error loading image rcpbs id #{@rcpbs.id}"
              end


            end

            if found_image == false
              # try directory for sku named file
              src_sku_image = %Q{#{@local_site_path}/images/#{@rcpbs.new_pbs_desc_1.strip}*} rescue ''
              array_of_found_sku_images = Dir.glob(src_sku_image)
              if !array_of_found_sku_images.empty?
                @product.images <<  Spree::Image.create!(:attachment => File.open(array_of_found_sku_images.first))
                @product.save!
              end
           end


            logger.info "Product #{@rcpbs.item} created in Spree"
            puts "Product #{@rcpbs.item} created in Spree"
            @products_created += 1

            @position += 1


            #if item_with_mu.ltiple_variants
              create_variant(rcpbs,@wi,logger)
            #else
              #v = @product.master
              #v.update_attribute(:item_no,rcpbs.new_pbs_item)
            #end

          end

        rescue Exception => e
          rcpbs_id =  @rcpbs.id rescue ''
          wiid = ''
          if @wi
            wiid = @wi.id
          end
          logger.info "Error:#{e.to_s} rcpbs_id #{rcpbs_id rescue ''} Web_item_id #{wiid}"
          puts "Error:#{e.to_s} rcpbs_id #{rcpbs_id rescue ''} Web_item_id #{wiid}"
          csv << [rcpbs_id,wiid,e.to_s]
          @error_items += 1
          next
        end

    end

  logger.info "Job Done Products Added #{@products_created} , Varients Added #{@variants_created} and Erros #{@error_items}"
  puts "Job Done Products Added #{@products_created} , Varients Added #{@variants_created} and Erros #{@error_items}"

end





BEGIN{
          # functions
          def item_type(pbs_item_rec)
            itemtype = ''
            case
              when pbs_item_rec.ws_cat =~ /ribbon/i
                itemtype = "Ribbon"
              when pbs_item_rec.ws_cat =~ /bow/i
                itemtype =  "Bow"
              when  pbs_item_rec.desc =~ /ribbon/i
                itemtype = "Ribbon"
              when pbs_item_rec.desc =~ /bow/i
                itemtype =  "Bow"
              when  pbs_item_rec.desc =~ /flower/i
                itemtype = "Flower"
              when pbs_item_rec.ws_cat =~ /flowers/i
                itemtype =  "Flower"
              else
                itemtype = pbs_item_rec.ws_cat.strip.titlecase
            end
          end

          def get_formed_cat_name(webcat)
            webcat.downcase.gsub('ribbon','').gsub('bows','').gsub('flowers','').strip.titlecase rescue ''
          end

          def get_master_sku(sku)
            t = sku.split('-')
            %Q{#{t[0]}-#{t[1]}}
          end


          def suggest_sku(rcpbs,logger,flow_sub,csv)
            if !(@item_type == 'Flower') #@wi
              width = rcpbs.width.scan(/[^-"\s]/).join('')  rescue ''
              if (!width.strip.empty? && (rcpbs.item.count('-') > 1))
                item_array = rcpbs.item.split('-')
                if item_array.include?(width)
                  item_array.delete(width)
                else
                  # assume 2nd portion of array is width?
                  item_array.delete_at(1)
                end
              else
                # lost cause log and next
                wid = (@wi) ? @wi.id : ''
                logger.info "Cannot use remove width logic  RcPBS Id: #{rcpbs.id} Using ws_cat ws_subcat ws_color"
                puts "Cannot use remove width logic  RcPBS Id: #{rcpbs.id} Using ws_cat ws_subcat ws_color"
                @error_items += 1
                csv << [rcpbs.id,wid,"Cannot use remove width logic  RcPBS Id: #{rcpbs.id} Using ws_cat ws_subcat ws_color"]
                item_array = [rcpbs.ws_cat,rcpbs.ws_subcat,rcpbs.ws_color] #next
              end
              prod_sku =  item_array.join('-')
            else
              prod_sku = flow_sub
            end

          end

          def create_variant(rcpbs,wi,logger)

            @position += 1
            v =  Spree::Variant.find_by_sku(rcpbs.new_pbs_desc_1)
            if v.nil?
              # create Variant
              v = Spree::Variant.new(
                  sku: rcpbs.new_pbs_desc_1,
                  product_id: @product.id,
                  is_master: @is_master,
                  price: rcpbs.rc_price,
                  cost_currency: "USD",
                  track_inventory: true,
                  tax_category_id: 1,
                  stock_items_count: 1,
                  item_no: rcpbs.new_pbs_item
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
                  elsif av.last == 'bow-size'
                    val = rcpbs.new_pbs_desc_3.split(",").last rescue ''
                    srcval = val
                  elsif av.last == 'width'
                    val = rcpbs.width rescue ''
                    srcval = val
                  elsif av.last == 'color'
                    val = rcpbs.ws_color.titlecase rescue ''
                    srcval = val
                  else
                    val = rcpbs.new_pbs_desc_3.split(",").last rescue ''
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

              if wi
                #create product image
                begin
                  image_path = %Q{#{@local_site_path}#{wi.image_file[/images.*/i,0]}} rescue ''
                  if File.exists?(image_path) && (!@wi.image_file.nil? && !@wi.image_file.blank)
                    v.images <<  Spree::Image.create!(:attachment => File.open(image_path))
                    v.save!
                  end
                rescue Exception => e
                  puts "#{e.to_s} error loading image rcpbs id #{rcpbs.id}"
                end
              else

                begin
                  # lets try an image with sku as the name
                  src_sku_image = %Q{#{@local_site_path}/images/#{rcpbs.new_pbs_desc_1.strip}*} rescue ''
                  array_of_found_sku_images = Dir.glob(src_sku_image)
                  if !array_of_found_sku_images.empty?
                    v.images <<  Spree::Image.create!(:attachment => File.open(array_of_found_sku_images.first))
                    v.save!
                  end
                rescue Exception => e
                  puts "#{e.to_s} error loading image rcpbs id #{rcpbs.id}"
                end

              end

              logger.info "Variant #{rcpbs.new_pbs_desc_1} created in Spree"
              puts "Variant #{rcpbs.new_pbs_desc_1} created in Spree"
              @variants_created += 1
            else
              logger.info "Variant #{rcpbs.new_pbs_desc_1} exists"
              puts "Variant #{rcpbs.new_pbs_desc_1} exists"
            end
          end



}



