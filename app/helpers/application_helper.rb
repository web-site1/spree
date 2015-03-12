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
    if ((params.has_key?(:quick_search) && params[:quick_search] == 'Y')||skip_quick)
      if params.has_key?(name.to_sym) && params[name.to_sym].include?(val)
        selected = opt
      end
    end
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


end
