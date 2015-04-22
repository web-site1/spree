module SearchHelper

  def search_solr(srch_params = {})
    solr_search(srch_params)
  end


  private

  def solr_search(srch_params={})
    @searcher = build_searcher(srch_params.merge(include_images: true))

  end

end