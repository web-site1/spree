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
    types = Spree::Taxon.where(parent_id: 1)
    types.each do |t|
      eopt = Spree::Taxon.where(parent_id: t.id)
      opts ={}
      eopt.each do |eo|
        subopt = Spree::Taxon.where(parent_id: eo.id)
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
          index_of_subcat = selected_cat[selected_cat.keys.first].last.index{|a| a.first.split('/').last == subcat}
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
    Spree::Taxon.where(parent_id: taxon.id)
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


end
