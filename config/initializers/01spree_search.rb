module Spree::Search
  class Solr
    attr_accessor :current_user
    attr_accessor :current_currency

    def initialize(params = {})
      page = (params[:page].to_i <= 0) ? 1 : params[:page].to_i
      @search_result =
          Sunspot.search(Spree::Product) do
            # execute your search here
            puts params

            fulltext params[:keywords] unless params[:keywords].blank?

            if params.has_key?(:color) && !(params[:color].include?('place-holder'))
              with(:color).any_of(params[:color])
            end

            if params.has_key?(:type) && !(params[:type].include?('place-holder'))
              with(:type).any_of(params[:type])
            end

            if params.has_key?(:widths) && !(params[:widths].include?('place-holder'))
              with(:widths).any_of(params[:widths])
            end

            if params.has_key?(:ribbon_putups) && !(params[:ribbon_putups].include?('place-holder'))
              with(:ribbon_putups).any_of(params[:ribbon_putups])
            end

            if params.has_key?(:pattern) && !(params[:pattern].include?('place-holder'))
              with(:pattern).any_of(params[:pattern])
            end
            facet :pattern
            facet :wired
            facet :type
            facet :widths
            facet :ribbon_putups
            facet :color
            facet :pattern
            facet :wired

            per_page = (params.has_key?(:per_page)) ? params[:per_page] : Spree::Config[:products_per_page]

            paginate page: page, per_page: per_page
          end
    end

    def retrieve_products
      @search_result.results
    end

    def get_search_obj
      return @search_result
    end

  end
end