BEGIN{
  # functions
  def item_type(pbs_item_rec)
    itemtype = ''
    case
      when pbs_item_rec.ws_cat =~ /tulle & trim/i
        itemtype = "tulle & trim"
      when pbs_item_rec.item.strip[0..1].downcase == 'cq'
        itemtype = "Flower"
      when pbs_item_rec.ws_cat =~ /ribbon/i
        itemtype = "Ribbon"
      when pbs_item_rec.ws_cat =~ /bow/i
        itemtype =  "Bow"
      when pbs_item_rec.ws_cat =~ /flower/i
        itemtype =  "Flower"
      when  pbs_item_rec.description =~ /ribbon/i
        itemtype = "Ribbon"
      when pbs_item_rec.description =~ /bow/i
        itemtype =  "Bow"
      when  pbs_item_rec.description =~ /flower/i
        itemtype = "Flower"
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
        logger.info "Cannot determine master sku Id: #{rcpbs.id} " if logger
        puts "Cannot determine master sku Id: #{rcpbs.id} "
        @error_items += 1
        csv << [rcpbs.id,"Cannot use remove width logic  RcPBS Id: #{rcpbs.id} Using ws_cat ws_subcat ws_color"] if csv
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
          src_image = get_image_path(rcpbs)

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



  WIDTH_CODES = {
      '1/4' => '001',
      '1/2' => '002',
      '5/8' => '003',
      '5/8' => '005',
      '11/2'=> '009',
      '21/2'=> '040',
      '3/8' => '105',
      '6'   => '300'
  }


  def get_replaced_inches_name(rcpbs,find_by_des = false)
    width = rcpbs.item_prod_sub_cat
    width = width.split('/')
    first =  width.first.scan(/./).join('-')
    second = width.last
    new_width = %Q{#{first}-#{second}}
    if find_by_des
      rcpbs.new_pbs_desc_1.gsub(rcpbs.item_prod_sub_cat,new_width)
    else
      rcpbs.item.gsub(rcpbs.item_prod_sub_cat,new_width)
    end

  end

  def get_image_path(rcpbs)
    src_image = rcpbs.item.gsub('/','-')
    src_image = %Q{#{@local_site_path}images/#{src_image.strip.gsub(' ','-')}.jpg} rescue ''


    if !File.file?(src_image)
      src_image = rcpbs.item.gsub('/','-').downcase
      src_image = %Q{#{@local_site_path}images/#{src_image.strip.gsub(' ','-')}.jpg} rescue ''
    end


    if !File.file?(src_image)
      #try removing
      itm_ar = rcpbs.item.gsub('/','-').split('-')
      itm_ar.last.gsub!(/\d+/,'')
      src_image = itm_ar.join('-')
      src_image = %Q{#{@local_site_path}images/#{src_image.strip.gsub(' ','-')}.jpg} rescue ''
    end



    if !File.file?(src_image)
      src_image = rcpbs.item.gsub('/','-').upcase
      src_image = %Q{#{@local_site_path}images/#{src_image.strip.gsub(' ','-')}.jpg} rescue ''
    end

    if !File.file?(src_image)
      src_image = get_replaced_inches_name(rcpbs)
      src_image = %Q{#{@local_site_path}images/#{src_image.strip.gsub(' ','-')}.jpg} rescue ''
    end

    if !File.file?(src_image)
      src_image = rcpbs.item.gsub('/','-')
      src_image_bad = %Q{#{@local_site_path}images/#{src_image.strip.gsub(' ','-')}} rescue ''
      src_image = %Q{#{@local_site_path}images/#{src_image.strip.gsub(' ','-')}.jpg} rescue ''
      if File.file?(src_image_bad)
        File.rename(src_image_bad,src_image)
      end
    end

    if !File.file?(src_image)
      #try Flowers
      color = rcpbs.ws_color.downcase
      src_image = rcpbs.item.gsub(rcpbs.ws_color.strip,color.strip.gsub(' ','-'))
      src_image = %Q{#{@local_site_path}images/#{src_image.strip.gsub(' ','-')}.jpg} rescue ''
    end



    if !File.file?(src_image)
      replaced_item = get_replaced_inches_name(rcpbs)
      src_image = replaced_item.sub(/-/,'')
      src_image = %Q{#{@local_site_path}images/#{src_image.strip.gsub(' ','-')}.jpg} rescue ''
    end

    if !File.file?(src_image)
      src_image = rcpbs.new_pbs_desc_1.gsub('/','-')
      src_image = %Q{#{@local_site_path}images/#{src_image.strip.gsub(' ','-')}.jpg} rescue ''

      if !File.file?(src_image)
        #try removing
        itm_ar = rcpbs.new_pbs_desc_1.gsub('/','-').split('-')
        itm_ar.last.gsub!(/\d+/,'')
        src_image = itm_ar.join('-')
        src_image = %Q{#{@local_site_path}images/#{src_image.strip.gsub(' ','-')}.jpg} rescue ''
      end

      if !File.file?(src_image)
        src_image = get_replaced_inches_name(rcpbs,true)
        src_image = %Q{#{@local_site_path}images/#{src_image.strip.gsub(' ','-')}.jpg} rescue ''
      end

      if !File.file?(src_image)
        src_image = rcpbs.new_pbs_desc_1.gsub('/','-')
        src_image_bad = %Q{#{@local_site_path}images/#{src_image.strip.gsub(' ','-')}} rescue ''
        src_image = %Q{#{@local_site_path}images/#{src_image.strip.gsub(' ','-')}.jpg} rescue ''
        if File.file?(src_image_bad)
          File.rename(src_image_bad,src_image)
        end
      end

      if !File.file?(src_image)
        #try Flowers
        color = rcpbs.ws_color.downcase
        src_image = rcpbs.new_pbs_desc_1.gsub(rcpbs.ws_color.strip,color.strip)
        src_image = %Q{#{@local_site_path}images/#{src_image.strip.gsub(' ','-')}.jpg} rescue ''
      end

      if !File.file?(src_image)
        replaced_item = get_replaced_inches_name(rcpbs,true)
        src_image = replaced_item.sub(/-/,'')
        src_image = %Q{#{@local_site_path}images/#{src_image.strip.gsub(' ','-')}.jpg} rescue ''
      end
    end

    if !File.file?(src_image)
      src_image = get_mapped_code_item(rcpbs)
      if src_image.class == Array
        f = src_image.first
        src_image = %Q{#{@local_site_path}images/#{f.strip.gsub(' ','-')}.jpg} rescue ''
        if !File.file?(src_image)
          f = src_image.last
          src_image = %Q{#{@local_site_path}images/#{f.strip.gsub(' ','-')}.jpg} rescue ''
        end
      else
        src_image = %Q{#{@local_site_path}images/#{src_image.strip.gsub(' ','-')}.jpg} rescue ''
      end

    end

    if !(@item_type == 'Flower')
      #Widcard match first found on sku
      if !File.file?(src_image)
        # try wilcard mapped coded item first with last section removed
        coded = get_mapped_code_item(rcpbs)
        coded_array = coded.split('-')
        code = coded_array.first(3).join('-')
        chk_array = Dir.glob(%Q{#{@local_site_path}images/#{code}*})

        if !chk_array.empty?
          src_image = chk_array.first
        end

        #flow_sub =  rcpbs.item.split('-')[0..1].join('-')
        #prod_sku = suggest_sku(rcpbs,nil,flow_sub,nil)
      end

      if !File.file?(src_image)
        # try wilcard mapped coded item first with last section removed
        flow_sub =  rcpbs.item.split('-')[0..1].join('-') rescue ''
        prod_sku = suggest_sku(rcpbs,nil,flow_sub,nil)
        prod_array = prod_sku.split('-')

        if prod_array.count > 2
          srch = %Q{#{prod_array.first(2).join('-')}*#{prod_array.last.gsub(/[^\d]/, '')}}
        else
          srch = %Q{#{prod_array.first}*#{prod_array.last.gsub(/[^\d]/, '')}}
        end

        chk_array = Dir.glob(%Q{#{@local_site_path}images/#{srch}*})

        if !chk_array.empty?
          src_image = chk_array.first
        else
          # check sub
          srch = flow_sub.gsub('-','*')
          chk_array = Dir.glob(%Q{#{@local_site_path}images/#{srch}*})
          src_image = chk_array.first if !chk_array.empty?
        end



        if !File.file?(src_image)
          if prod_array.count > 2
            srch = %Q{#{prod_array.first}*#{prod_array.last.gsub(/[^\d]/, '')}}
            chk_array = Dir.glob(%Q{#{@local_site_path}images/#{srch}*})
            if !chk_array.empty?
              src_image = chk_array.first
            end
          end
        end
      end



    end


    return src_image
  end


  def get_mapped_code_item(rcpbs)
    ba = rcpbs.new_pbs_desc_1.split('-')

    is_array_rtn = false
    # '5/8' => '005'
    if ba[1] == '5/8'
      is_array_rtn = true
    end

    if is_array_rtn
      ["#{ba[0]}-003-#{ba[3]}-#{ba[2]}","#{ba[0]}-005-#{ba[3]}-#{ba[2]}"]
    else
      "#{ba[0]}-#{WIDTH_CODES[ba[1]]}-#{ba[3]}-#{ba[2]}"
    end
  end




}