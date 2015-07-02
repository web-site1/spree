module ApplicationHelper

  include SearchHelper
  include Spree::Core::ControllerHelpers::Search


  def srch_opts(opt_name='')
    opts_array = []
    if !@searcher
      @searcher = search_solr()
    end
    solr_search_obj = @searcher.get_search_obj
    solr_search_obj.facet(opt_name.to_sym).rows.each do |facet|
      if facet.count.to_i > 0
        if !(opt_name.to_sym == :ribbon_putups && !(facet.value[0] =~ /[0-9]/))
          fv = facet.value
          if opt_name.to_sym == :wired
            fv = (facet.value == false) ? 'Non-wired' : 'Wired'
          end
          opts_array << [fv,facet.count]
        end
      end
    end rescue ''
    opts_array.sort! if  !(opt_name.to_sym == :wired)
    return opts_array

  end

  def src_selected(name='',val='',opt='selected',skip_quick=false)
    selected=''
    #if ((params.has_key?(:quick_search) && params[:quick_search] == 'Y')||skip_quick)
      if params.has_key?(name.to_sym) && params[name.to_sym].include?(val)
        selected = opt unless (skip_quick==false)&&(params[name.to_sym].count > 1)
      end
    #end
    return selected
  end

  def position_sort(array_facet_count = [],type = '')

    position_sorted_array = []
    option = Spree::OptionType.find_by_name(type)
    ov = Spree::OptionValue.where(option_type_id: option.id)
    array_of_vals = array_facet_count.map{|f| f.first}
    position_sorted_array = ov.select{|ovs| array_of_vals.include?(ovs.name)}.map{|v| v.name}

    return position_sorted_array
  end

  def side_search_cats
    type_hash = {}
    @all_tax_cats = Spree::Taxon.where(taxonomy_id: 1).order(:lft)
    types =  @all_tax_cats.select{|tax| tax.parent_id == 1 }  #Spree::Taxon.where(parent_id: 1)
    types.each do |t|
      eopt = @all_tax_cats.select{|tax| tax.parent_id == t.id } #t.children
      opts ={}
      eopt.each do |eo|
        subopt = @all_tax_cats.select{|tax| tax.parent_id == eo.id } #Spree::Taxon.where(parent_id: eo.id)
        sub_opts=[]
        subopt.each do |so|
          perma_link = so.permalink
          sub_opts << [perma_link,so.name]
        end
        perma_link = eo.permalink
        opts.merge!(eo.name => [perma_link,sub_opts])
      end
      perma_link = t.permalink
      type_hash.merge!(t.name => [perma_link,opts])
    end
    return type_hash
  end



  def reposition_selected_search_cats(search_cats,selected_hash)

    repositioned_hash = {}
    if !selected_hash.empty?
      type = selected_hash[:type]
      cat = selected_hash[:cat]
      subcat = selected_hash[:subcat]
      selected = search_cats.select{|k,v| v.first.split("/").last == type}
      search_cats.delete_if{|k,v| v.first.split("/").last == type}
      if !cat.blank?
        new_cat_hash = {}
        cat_hash_vals = selected[selected.keys.first].last
        selected_cat = cat_hash_vals.select{|k,v| v.first.split("/").last == cat}
        cat_hash_vals.delete_if{|k,v| v.first.split("/").last == cat}
        if !subcat.blank?
          index_of_subcat = selected_cat[selected_cat.keys.first].last.index{|a| a.first.split('/').last == subcat} rescue nil
          if index_of_subcat
            selected_cat[selected_cat.keys.first].last.insert(0,selected_cat[selected_cat.keys.first].last.delete_at(index_of_subcat))
          end
        end
        new_cat_hash.merge!(selected_cat)
        cat_hash_vals.each{|k,v| new_cat_hash.merge!(k => v)}
        cat_hash_vals = selected[selected.keys.first][1] = new_cat_hash
      end
      repositioned_hash.merge!(selected)
      search_cats.each{|k,v| repositioned_hash.merge!(k => v)}
    else
      repositioned_hash = search_cats
    end
    return repositioned_hash

  end


  def get_taxons_subcats(taxon)
    Spree::Taxon.where(parent_id: taxon.id).order(:lft)
  end

  def taxon_selection
    selected_hash = {}
    if params.has_key?(:id)
      taxon_split_array = params[:id].split("/")
      if taxon_split_array.first == 'categories'
        selected_hash.merge!(type: taxon_split_array[1] || ' ')
        selected_hash.merge!(cat: taxon_split_array[2] || ' ')
        selected_hash.merge!(subcat: taxon_split_array[3] || ' ')
      end
    end
    return selected_hash
  end

  def featured_products
    featured_taxon = Spree::Taxon.featured
    featured_products_array = []
    if !featured_taxon.empty?
      featured_products_array = featured_taxon.first.products
    end
    return featured_products_array
  end

  def new_arrivals(per_page = 30)
    #na = Spree::Product.where("available_on <= ?",Date.today).order(available_on: :desc).limit(10)
    @new_searcher = search_solr({:for_new_arrivals=> true,:per_page => per_page})
    na = @new_searcher.retrieve_products
  end


  def rate_range(rates,amt)
    rates.reject{|r| !r.shipping_method.sack_range.include?(amt) }
  end

  def art_ship_states(ship_state=nil)
    size = 10
    rtn = "Pending"

    if !ship_state.nil?
      rtn = ship_state
    end
    x = size - rtn.length
    if x > 0
      x.times do rtn = rtn + "&nbsp;" end
    end
    return rtn.html_safe
  end

  def mobile_agent?
    request.user_agent =~ /Mobile|webOS/
  end

  def agent_device
    if mobile_agent?
      'mobile'
    else
      'desktop'
    end
  end

  def get_promotion_and_display
    promo_dsply = ''
    promo_array = Spree::Promotion.active

    begin
      if !promo_array.empty?
        #assume always one active promo
        promo = promo_array.first
        promo_dsply =  promo.description
=begin
        action = promo.actions.first
        calculator = action.calculator
        if (calculator && (calculator.type =="Spree::Calculator::FlatPercentItemTotal"))
          percent = calculator.preferences[:flat_percent].to_i
          promo_dsply =
              %Q{<span class='promo-text'>#{percent}% <span style='color: red;'>SALE</span> on all items. Code:#{promo.code}</span>}
        end
=end
      end
    rescue Exception => e

    end

    return promo_dsply.html_safe
  end

end
