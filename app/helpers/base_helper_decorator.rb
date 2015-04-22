Spree::BaseHelper.module_eval do

  def art_breadcrumbs(taxon, separator="&nbsp;")
    return "" if current_page?("/") || taxon.nil?
    separator = raw(separator)
    crumbs = [content_tag(:li, content_tag(:span, link_to(Spree.t(:home), spree.root_path, itemprop: "url") + separator, itemprop: "title"), itemscope: "itemscope", itemtype: "http://data-vocabulary.org/Breadcrumb")]
    if taxon
      crumbs << content_tag(:li, content_tag(:span, link_to(Spree.t(:products), spree.products_path, itemprop: "url") + separator, itemprop: "title"), itemscope: "itemscope", itemtype: "http://data-vocabulary.org/Breadcrumb")
      crumbs << taxon.ancestors.collect { |ancestor| content_tag(:li, content_tag(:span, link_to(ancestor.name , seo_url(ancestor), itemprop: "url") + separator, itemprop: "title"), itemscope: "itemscope", itemtype: "http://data-vocabulary.org/Breadcrumb") } unless taxon.ancestors.empty?
      crumbs << content_tag(:li, content_tag(:span, link_to(taxon.name , seo_url(taxon), itemprop: "url"), itemprop: "title"), class: 'active', itemscope: "itemscope", itemtype: "http://data-vocabulary.org/Breadcrumb")
    else
      crumbs << content_tag(:li, content_tag(:span, Spree.t(:products), itemprop: "title"), class: 'active', itemscope: "itemscope", itemtype: "http://data-vocabulary.org/Breadcrumb")
    end
    crumb_list = content_tag(:ol, raw(crumbs.flatten.map{|li| li.mb_chars}.join), class: 'breadcrumb')
    #content_tag(:nav, crumb_list, id: 'breadcrumbs', class: 'col-md-12')
  end

end