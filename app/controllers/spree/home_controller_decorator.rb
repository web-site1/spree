Spree::HomeController.class_eval do

  def why_shop
    id = params[:id]
    @partial = 'about_us'
    if params.has_key?(:id) && !params[:id].blank?
      @partial = params[:id]
    end
  end

end