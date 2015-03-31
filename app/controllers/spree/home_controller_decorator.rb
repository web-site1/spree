Spree::HomeController.class_eval do

  def why_shop
    id = params[:id]
    @partial = 'about_us'
    if id == 'dedicated'
      @partial = 'dedicated'
    elsif id == 'last_opt'
      @partial = 'last_opt'
    end
  end

end