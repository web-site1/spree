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


log_file_name = %Q{sport_Item_create-#{Time.now.strftime("%m%d%y%I%M")}.log}
log_file =  %Q{#{Rails.root}/log/#{log_file_name}}
logger = Logger.new(log_file)
logger.info "Starting to create Items"
puts "Starting to create Items"
puts Spree::Image.attachment_definitions[:attachment].inspect

csv_error_file =  %Q{#{Rails.root}/log/sport_item_import_errors.csv}



# create and gather the needed properties for main item

@products_created = 0
@variants_created = 0
@error_items = 0


#@local_site_path = "/Users/dsadaka/Dropbox/DEV/Artistic/sitesucker/www.artisticribbon.com/"
if Rails.env == 'staging'
  @local_site_path =   "/var/www/artspree3/"
else
  @local_site_path = "/home/louie/Dropbox/DEV/Artistic/sitesucker/www.artisticribbon.com/"
  #@local_site_path = "/tmp/t/"
end

puts "Local image directory is #{@local_site_path}"
# Properties
@properties_hash = {}
# color

=begin
@color_prop = Spree::Property.find_by_name('color')
if @color_prop.nil?
  @color_prop = Spree::Property.create(
      name: "Color",
      presentation: "Color"
  )
end
@properties_hash.merge!(color: [@color_prop,"rcpbs.ws_color"] )
=end



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

=begin
ribbon_width_option = Spree::OptionType.find_by_name('ribbon-width')
if ribbon_width_option.nil?
  ribbon_width_option = Spree::OptionType.create(
      name: 'ribbon-width',
      presentation: 'Width'
  )
end
@ribbon_option_hash.merge!(width: ribbon_width_option)
=end

width_option = Spree::OptionType.find_by_name('width')

if width_option.nil?
  width_option = Spree::OptionType.create(
      name: 'width',
      presentation: 'Width'
  )
end

@ribbon_option_hash.merge!(width: width_option)




ribbon_putup_option = Spree::OptionType.find_by_name('ribbon-putup')
if ribbon_putup_option.nil?
  ribbon_putup_option = Spree::OptionType.create(
      name: 'ribbon-putup',
      presentation: 'Putup'
  )
end
@ribbon_option_hash.merge!(putup: ribbon_putup_option)
# no color for sports
#@ribbon_option_hash.merge!(color: all_color_option)


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
flower_width_option = width_option # Spree::OptionType.find_by_name('width')

if flower_width_option.nil?
  flower_width_option = Spree::OptionType.create(
      name: 'width',
      presentation: 'Width'
  )
end

@flower_option_hash.merge!(width: flower_width_option)
@flower_option_hash.merge!(color: all_color_option)


#NFL Accessories option
@nfl_accessories_option_hash = {}

count_option = Spree::OptionType.find_by_name('count')

if count_option.nil?
  count_option = Spree::OptionType.create(
      name: 'count',
      presentation: 'Count'
  )
end

@nfl_accessories_option_hash.merge!(count: count_option)



@flower_taxon_sizes = {
    '4.5 - 5.5 Inches' => (4.5..5.5),
    '4 - 4.5 Inches' => (4..4.5),
    '3.5 - 4 Inches' => (3.5..4),
    '2.5 - 3 Inches' => (2.5..3),
    '2 - 2.5 Inches' => (2..2.5),
    '1.5 - 2 Inches' => (1.5..2),
    '1 - 1.5 Inches' => (1..1.5),
    'under 1 inch ' => (0..0.9999999)
}





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

    #r = RcPbs.joins( "left JOIN web_items on web_items.item = rc_pbs.item").order('web_items.page').limit(30)
    #r = RcPbs.find(186691,186743,186795,186847,186899,186951,187003)
    #r = RcPbs.where(ws_subcat: "CQA-62.")
    #r = RcPbs.find(190593, 190594, 190595, 190596, 190597, 190598, 190599, 190600, 190601, 190602, 190603, 190604, 190605, 190606, 190608, 190609, 190610, 190611, 190612, 190613, 190614, 190615, 190616, 190617, 190618, 190619, 190620, 190621, 190622, 190623, 190624)

    r = Sport.where("ws_cat IN( 'NFL Licensed Ribbon','MLB Ribbon', 'Collegiate Licensed Ribbon')").order(:ws_cat,:ws_subcat,:ws_color).limit(10)
    r.each do |rcpbs|

      web_item = rcpbs.web_item
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



          #
          if @rcpbs.ws_cat.downcase == 'nfl accessories'
            prod_name =  %Q{#{@rcpbs.new_pbs_desc_3}}.gsub(@rcpbs.width,'').strip.titlecase

            @item_type = 'NFL Accessories'
          else
            prod_name = %Q{#{@rcpbs.ws_subcat.strip} #{@rcpbs.ws_cat.strip} #{@rcpbs.ws_color.strip}}.titlecase
            @item_type = 'Ribbon'

          end
          #prod_sku = %Q{#{@rcpbs.ws_subcat.strip} #{@rcpbs.ws_cat.strip} #{@rcpbs.ws_color.strip}}
          prod_sku = %Q{#{@rcpbs.ws_subcat.strip} #{@rcpbs.ws_cat.strip} #{@rcpbs.ws_color.strip} #{@rcpbs.item}}





          #@product = Spree::Product.find_by_name(prod_name)
          prod_var = Spree::Variant.find_by_sku(prod_sku)

          if !prod_var.nil?
            @product = prod_var.product
          else
            @product = nil
          end


          if !@product.nil?
            create_variant(rcpbs,@wi,logger)
          else


            p_meta = @wi.description
            p_key = @wi.keywords

            if @rcpbs.ws_cat.downcase == 'nfl accessories'
              p_des = %Q{These NFL Accessories are fun to wear or for decorating to show team spirit at it's best.}
              p_des += %Q{ All come 3 to a pack.}
            else
              #p_des = %Q{This #{@rcpbs.ws_subcat.strip.titlecase} ribbon captures team spirit at its best. }
              #p_des += %Q{Manufactured as a 100% polyester woven-edge satin ribbon, this pattern is offered }
              #p_des += %Q{in a #{@rcpbs.ws_color.strip.downcase.gsub('spool','').gsub('spools','').titlecase} spool. Select your desired putup, width and pattern.}

              if !@rcpbs.width.blank?
                prod_name = %Q{#{@rcpbs.ws_subcat} #{@rcpbs.width}x#{@rcpbs.putup_pack.gsub('feet',"'")},#{@rcpbs.ws_color.gsub('spool','-')} }
                p_des =  %Q{#{@rcpbs.ws_subcat.titlecase} #{@rcpbs.ws_cat.titlecase}. 100% polyester woven-edge satin. Offered in #{@rcpbs.width}x#{@rcpbs.putup_pack.gsub('feet',"'")},#{@rcpbs.ws_color.gsub('spool','-spool').gsub('pack','')} packs.}
              else
                prod_name = %Q{#{@rcpbs.ws_subcat} 4-PACK SPECIAL }
                p_des =  %Q{#{@rcpbs.ws_color}. #{@rcpbs.ws_subcat.titlecase}. #{@rcpbs.desc.scan( /Ribbon patterns*.*/).first}}
              end

            end



            @product = Spree::Product.new(
              name: prod_name,
              description: p_des,
              available_on: Date.today()-1.day,
              shipping_category_id: 1 ,
              meta_description: p_meta,
              meta_keywords: p_key,
              price: rcpbs.rc_price.to_f,
              sku: prod_sku #rcpbs.item
            )

            # find taxon record
            main_cat = Spree::Taxon.find_by_name(@rcpbs.ws_cat.titleize)

            taxonrec = Spree::Taxon.find_by_name_and_parent_id(@rcpbs.ws_subcat.titleize,main_cat.id)

            if taxonrec.nil?
              logger.info "Product #{@rcpbs.item} cannot determine taxon"
              puts "Product #{@rcpbs.item} cannot determine taxon"
              next
            end



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
            else
              option_hash = @nfl_accessories_option_hash
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
              #create product image
                image_path = %Q{#{@local_site_path}#{@wi.image_file[/images.*/i,0]}} rescue ''
                if File.exists?(image_path) && (!@wi.image_file.nil? && !@wi.image_file.blank?)
                  found_image = true
                  @product.images <<  Spree::Image.create!(:attachment => File.open(image_path))
                  @product.save!
                else
                  logger.info "no image #{@rcpbs.item} file #{@wi.image_file}"
                  puts "no image #{@rcpbs.item} file #{@wi.image_file}"
                end
              rescue Exception => e
                puts "#{e.to_s} error loading image rcpbs id #{@rcpbs.id}"
              end


=begin
              if (@wi.image_file.nil? || @wi.image_file.blank?)
                begin
                  #create swatch image if it exsists
                  swatch_image_path = %Q{#{@local_site_path}#{@wi.swatch_image_file[/images.*/i,0]}} rescue ''
                  if File.exists?(swatch_image_path) && (!@wi.swatch_image_file.nil? && !@wi.swatch_image_file.blank?)
                    @product.images <<  Spree::Image.create!(:attachment => File.open(swatch_image_path))
                    @product.save!
                  end
                rescue Exception => e
                  puts "#{e.to_s} error loading image rcpbs id #{@rcpbs.id}"
                end
              end
=end



            end

=begin
            if found_image == false
              # try directory for sku named file
              src_sku_image = %Q{#{@local_site_path}/images/#{@rcpbs.new_pbs_desc_1.strip}*} rescue ''
              array_of_found_sku_images = Dir.glob(src_sku_image)
              if !array_of_found_sku_images.empty?
                @product.images <<  Spree::Image.create!(:attachment => File.open(array_of_found_sku_images.first))
                @product.save!
              end
           end
=end


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
              when pbs_item_rec.item.strip[0..1].downcase == 'cq'
                itemtype = "Flower"
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


          def get_flower_taxon(rcpbs)
            cat = ''
            @flower_taxon_sizes.each do |k,v|
              if (v.include?(rcpbs.width.to_dec))
                cat = k
                break
              end
            end
            return cat
          end

          def create_main_type_taxon(item_type)
            top_parent_taxon = Spree::Taxon.find_by_name('Categories')
            main_cat_taxon = Spree::Taxon.find_by_parent_id_and_name(top_parent_taxon.id,item_type)
            if main_cat_taxon.nil?
              main_cat_taxon = Spree::Taxon.create(parent_id: top_parent_taxon.id,name: item_type.titlecase )
            end
            return main_cat_taxon
          end

          def create_flower_taxon(item_type,flower_taxon)
            top_parent_taxon = Spree::Taxon.find_by_name('Categories')
            item_type = %Q{#{item_type}s}
            main_cat_taxon = Spree::Taxon.find_by_parent_id_and_name(top_parent_taxon.id,item_type)
            if main_cat_taxon.nil?
              main_cat_taxon = create_main_type_taxon(item_type)
            end
            item_taxon = Spree::Taxon.find_by_parent_id_and_name(main_cat_taxon.id,flower_taxon)
            if item_taxon.nil?
              item_taxon = Spree::Taxon.create(parent_id: main_cat_taxon.id,name: flower_taxon )
            end
            return item_taxon
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
                  elsif av.last == 'count'
                    val = rcpbs.width rescue ''
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


              #if (@item_type == 'Flower')

=begin
                found_image = false
                if wi
                  #create product image
                  begin
                    image_path = %Q{#{@local_site_path}#{wi.image_file[/images.*/i,0]}} rescue ''
                    if File.exists?(image_path) && (!@wi.image_file.nil? && !@wi.image_file.blank?)
                      found_image = true
                      v.images <<  Spree::Image.create!(:attachment => File.open(image_path))
                      v.save!
                    else
                      logger.info "no image #{@rcpbs.item} file #{@wi.image_file}"
                      puts "no image #{@rcpbs.item} file #{@wi.image_file}"
                    end
                  rescue Exception => e
                    puts "#{e.to_s} error loading image rcpbs id #{rcpbs.id}"
                  end
                end
=end

=begin
                if found_image == false
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
=end
              #end

              logger.info "Variant #{rcpbs.new_pbs_desc_1} created in Spree"
              puts "Variant #{rcpbs.new_pbs_desc_1} created in Spree"
              @variants_created += 1


=begin
              # At this point check if the product has an empty description and if
              # it does attempt to fill it if a Web item exsists
              var_prod = v.product
              if var_prod && var_prod.description.blank?  && !wi.nil?
                if wi.top_description && !wi.top_description.empty?
                  var_prod.description = wi.top_description
                else
                  var_prod.description = wi.description
                end
                var_prod.save
              end
=end


            else
              logger.info "Variant #{rcpbs.new_pbs_desc_1} exists"
              puts "Variant #{rcpbs.new_pbs_desc_1} exists"
            end
          end



}



