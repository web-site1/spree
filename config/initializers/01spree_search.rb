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

            if params.has_key?(:color) && !(params[:color] == 'place-holder')
              with(:color,params[:color])
            end

            if params.has_key?(:color) && !(params[:type] == 'place-holder')
              with(:type,params[:type])
            end

            if params.has_key?(:width) && !(params[:width] == 'place-holder')
              with(:width,params[:width])
            end

            if params.has_key?(:put_up) && !(params[:put_up] == 'place-holder')
              with(:put_up,params[:put_up])
            end

            if params.has_key?(:pattern) && !(params[:pattern] == 'place-holder')
              with(:pattern,params[:pattern])
            end
            facet :pattern
            facet :wired
            facet :type
            facet :widths
            facet :ribbon_putups
            facet :colors
            facet :pattern
            facet :wired

            paginate page: page, per_page: Spree::Config[:products_per_page]
          end
    end

    def retrieve_products
      @search_result.results
    end
  end
end