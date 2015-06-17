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

            if params.has_key?(:diameters) && !(params[:diameters].include?('place-holder'))
              with(:diameters).any_of(params[:diameters])
            end

            if params.has_key?(:tote_sizes) && !(params[:tote_sizes].include?('place-holder'))
              with(:tote_sizes).any_of(params[:tote_sizes])
            end

            if params.has_key?(:ribbon_putups) && !(params[:ribbon_putups].include?('place-holder'))
              with(:ribbon_putups).any_of(params[:ribbon_putups])
            end

            if params.has_key?(:pattern) && !(params[:pattern].include?('place-holder'))
              with(:pattern).any_of(params[:pattern])
            end

            if params.has_key?(:wired) && !(params[:wired].include?('place-holder'))
              with(:wired).any_of(params[:wired])
            end

            if (params.has_key?(:for_new_arrivals) || params.has_key?(:for_new_flowers) ||
                params.has_key?(:for_new_ribbons) )
              date = 60.days.ago
              with(:available_on).between(date..Date.today)

              if params.has_key?(:for_new_flowers)
                with(:type,'flowers')
              elsif params.has_key?(:for_new_ribbons)
                with(:type,'ribbons')
                group :cat_pattern do
                  limit 1
                end
              end
            end


            order_by :available_on, :desc

            facet :pattern,:limit => -1
            facet :wired,:limit => -1
            facet :type,:limit => -1
            facet :widths,:limit => -1
            facet :diameters,:limit => -1
            facet :tote_sizes,:limit => -1
            facet :ribbon_putups,:limit => -1
            facet :color,:limit => -1
            facet :pattern,:limit => -1
            facet :wired,:limit => -1

            per_page = (params.has_key?(:per_page)) ? params[:per_page] : Spree::Config[:products_per_page]

            paginate page: page, per_page: per_page
          end
    end

    def retrieve_products
      if @search_result.group(:cat_pattern)
        @search_result.group(:cat_pattern).groups
      else
        @search_result.results
      end
    end

    def get_search_obj
      return @search_result
    end

  end
end