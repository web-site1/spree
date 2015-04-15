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
flower_width_option = width_option # Spree::OptionType.find_by_name('width')

if flower_width_option.nil?
  flower_width_option = Spree::OptionType.create(
      name: 'width',
      presentation: 'Width'
  )
end

@flower_option_hash.merge!(width: flower_width_option)
@flower_option_hash.merge!(color: all_color_option)




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






@position = 1

main_cat_taxon =  Spree::Taxon.find_by_name('Categories')

CSV.open(csv_error_file, "wb") do |csv|
  csv << ['rcpbs_id','wi_id','error']

    r = NewItem.where("new_pbs_item <> 'master'").order(:ws_cat,:ws_subcat).limit(10)
    r.each do |rcpbs|

      item_with_multiple_variants = false
      product_created = false


        begin
          @rcpbs = rcpbs

          @is_master = false

          @position = 1

          @item_type = item_type(rcpbs) ||  ''


          flow_sub =  @rcpbs.item.split('-')[0..1].join('-')  #@rcpbs.ws_subcat.downcase.strip.titlecase.gsub('.','')


          # find type taxon
          type_taxon = Spree::Taxon.find_by_name_and_parent_id(@item_type.pluralize,main_cat_taxon.id)
          if !type_taxon
            logger.info "No Taxon for type #{@item_type}"
            puts "No Taxon for type #{@item_type}"
            raise Exception.new("No type Taxon")
          end



          # find main cat taxon record
          main_cat = Spree::Taxon.find_by_name_and_parent_id(get_formed_cat_name(@rcpbs.ws_cat),type_taxon.id)
          if main_cat.nil?
            logger.info "No Main cat taxon #{get_formed_cat_name(@rcpbs.ws_cat)}"
            puts "Product #{@rcpbs.item} cannot determine main cat taxon"
            raise Exception.new("No type Taxon")
          end

          taxonrec = Spree::Taxon.find_by_name_and_parent_id(@rcpbs.ws_subcat.titleize,main_cat.id)


          master_rec = NewItem.find_by_item(master_desc_item(rcpbs))


          if taxonrec.nil?
            logger.info "Cannot determine taxon #{@rcpbs.ws_subcat.titleize} creating"
            puts "Cannot determine taxon #{@rcpbs.ws_subcat.titleize} creating"
            tdes = (master_rec) ? master_rec.description.strip.titlecase : ''

            meta_title = tdes
            meta_keywords = main_cat.permalink.split('/').join(',')
            meta_keywords +=  %Q{,#{@rcpbs.ws_subcat.titleize}}

            taxonrec = Spree::Taxon.create(
                parent_id: main_cat.id,
                name: @rcpbs.ws_subcat.titleize,
                taxonomy_id:main_cat_taxon.id,
                meta_description: tdes,
                meta_title: meta_title,
                meta_keywords: meta_keywords,
                description: tdes
            )
          else
            if taxonrec.description.blank? && master_rec
              taxonrec.update_attribute(:description,master_rec.description.strip.titlecase)
            end
          end





          prod_sku = suggest_sku(@rcpbs,logger,flow_sub,csv)

          if prod_sku.blank?
            raise Exception.new("Blank master sku")
          end


          sku_lookup = prod_sku

          if @item_type == 'Flower'
            sku_lookup = flow_sub
          end


          p_var = Spree::Variant.find_by_sku(sku_lookup)

          if p_var
            @product = p_var.product
          else
            @product = nil
          end



          if !@product.nil?
            create_variant(rcpbs,logger)
          else

              p_title = rcpbs.description.gsub(rcpbs.width,'').split('--').first.titlecase.strip

              p_des = ''

              if master_rec
                p_des = %Q{#{master_rec.description.strip.title_case} rcpbs.ws_color.titlecase}
              end

              p_meta = taxonrec.description
              p_key =  taxonrec.permalink.split('/').join(',')




            @product = Spree::Product.new(
              name: p_title,
              description: p_des,
              available_on: Date.today()-1.day,
              shipping_category_id: 1 ,
              meta_description: p_meta,
              meta_keywords: p_key,
              price: rcpbs.IQ2015 ,#rcpbs.rc_price.to_f,
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




            #create product image
            begin
              src_image = rcpbs.item.gsub('/','-')
              src_image = %Q{#{@local_site_path}images/#{src_image}.jpg} rescue ''

              if !File.file?(src_image)
                #try removing
                itm_ar = rcpbs.item.gsub('/','-').split('-')
                itm_ar.last.gsub!(/\d+/,'')
                src_image = itm_ar.join('-')
                src_image = %Q{#{@local_site_path}images/#{src_image}.jpg} rescue ''
              end

              if !File.file?(src_image)
                src_image = rcpbs.item.gsub('/','-')
                src_image_bad = %Q{#{@local_site_path}images/#{src_image}} rescue ''
                src_image = %Q{#{@local_site_path}images/#{src_image}.jpg} rescue ''
                if File.file?(src_image_bad)
                  File.rename(src_image_bad,src_image)
                end
              end



              if File.file?(src_image)
                @product.images <<  Spree::Image.create!(:attachment => File.open(src_image))
                @product.save!
              else
                puts "Could not find image #{src_image}"
                logger.info "Could not find image #{src_image}"
              end
            rescue Exception => e
              puts "#{e.to_s} error loading Flower Variant image id #{rcpbs.id}"
            end

            logger.info "Product #{@rcpbs.item} created in Spree"
            puts "Product #{@rcpbs.item} created in Spree"
            @products_created += 1

            @position += 1

            create_variant(rcpbs,logger)
          end

        rescue Exception => e
          rcpbs_id =  @rcpbs.id rescue ''
          logger.info "Error:#{e.to_s} rcpbs_id #{rcpbs_id rescue ''} "
          puts "Error:#{e.to_s} rcpbs_id #{rcpbs_id rescue ''} "
          csv << [rcpbs_id,e.to_s]
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
            webcat.downcase.gsub('ribbon','').gsub('check','checks').gsub('bows','').gsub('flowers','').strip.titlecase rescue ''
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
                  #width_index = item_array.index(width)
                  #width_index -= 1
                  #item_array = item_array[0..width_index]
                end
              else
                # lost cause log and next
                logger.info "Cannot determine master sku Id: #{rcpbs.id} "
                puts "Cannot determine master sku Id: #{rcpbs.id} "
                @error_items += 1
                csv << [rcpbs.id,"Cannot use remove width logic  RcPBS Id: #{rcpbs.id} Using ws_cat ws_subcat ws_color"]
                " " #next
              end
              prod_sku =  item_array.join('-')
            else
              prod_sku = flow_sub
            end

          end


          def master_desc_item(rcpbs)
            width = rcpbs.width.scan(/[^-"\s]/).join('')  rescue ''
            if (!width.strip.empty? && (rcpbs.item.count('-') > 1))
              item_array = rcpbs.item.split('-')
              if item_array.include?(width)
                #item_array.delete(width)
                width_index = item_array.index(width)
                width_index -= 1
                item_array = item_array[0..width_index]
              end
            end
            prod_sku =  item_array.join('-')
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


          def create_variant(rcpbs,logger)

            @position += 1
            v =  Spree::Variant.find_by_sku(rcpbs.new_pbs_desc_1)
            if v.nil?
              # create Variant
              v = Spree::Variant.new(
                  sku: rcpbs.new_pbs_desc_1,
                  product_id: @product.id,
                  is_master: @is_master,
                  price: rcpbs.IQ2015,
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


              if (@item_type == 'Flower')
                  begin
                    src_image = rcpbs.item.gsub('/','-')
                    src_image = %Q{#{@local_site_path}images/#{src_image}.jpg} rescue ''

                    if !File.file?(src_image)
                      #try removing
                      itm_ar = rcpbs.item.gsub('/','-').split('-')
                      itm_ar.last.gsub!(/\d+/,'')
                      src_image = itm_ar.join('-')
                      src_image = %Q{#{@local_site_path}images/#{src_image}.jpg} rescue ''
                    end


                    if !File.file?(src_image)
                      src_image = rcpbs.item.gsub('/','-')
                      src_image_bad = %Q{#{@local_site_path}images/#{src_image}} rescue ''
                      src_image = %Q{#{@local_site_path}images/#{src_image}.jpg} rescue ''
                      if File.file?(src_image_bad)
                        File.rename(src_image_bad,src_image)
                      end
                    end


                    if File.file?(src_image)
                      v.images <<  Spree::Image.create!(:attachment => File.open(src_image))
                      v.save!
                    else
                      puts "Could not find image #{src_image}"
                      logger.info "Could not find image #{src_image}"
                    end
                  rescue Exception => e
                    puts "#{e.to_s} error loading Flower Variant image id #{rcpbs.id}"
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



