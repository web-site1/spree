Spree::HomeController.class_eval do

  # skip_before_filter :force_ssl

  # Set headers in HTTP response to optimize browser cache.  Pass expiration in minutes
  before_filter {|c| c.set_headers 10.minutes}

  %w{page why_shop}.each do |m|
    define_method(m) do
      id = params[:id]
      @partial = 'about_us'
      if params.has_key?(:id) && !params[:id].blank?
        @partial = params[:id]
      end
      render :template => 'spree/home/why_shop'
    end
  end
end