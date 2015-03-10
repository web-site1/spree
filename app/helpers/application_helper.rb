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
          opts_array << [facet.value,facet.count]
        end
      end
    end rescue ''
    return opts_array.sort!
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

end
