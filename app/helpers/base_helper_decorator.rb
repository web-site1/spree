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

  def meta_data
    object = instance_variable_get('@'+controller_name.singularize)
    meta = {}

    if object.kind_of? ActiveRecord::Base
      meta[:keywords] = object.meta_keywords if object[:meta_keywords].present?
      meta[:description] = object.meta_description if object[:meta_description].present?
    end

    if meta[:description].blank? && object.kind_of?(Spree::Product)
      meta[:description] = strip_tags(truncate(object.description, length: 160, separator: ' '))
    end

    meta.reverse_merge!({
                            keywords: current_store.meta_keywords,
                            description: current_store.meta_description,
                        }) if meta[:keywords].blank? or meta[:description].blank?

    if (meta[:description].blank? rescue true)
      meta[:description] = 'Shop ribbons, craft ribbons, floral supplies, and floral accessories'
    end

    if params.has_key?(:keywords)
      meta[:keywords] = %Q{#{meta[:keywords]} #{params[:keywords]}}
    end

    meta
  end

end