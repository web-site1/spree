Spree::ProductsController.class_eval do

  def show_new_arrivals
    @quick_title = "New Arrivals"
    @products = Spree::Product.where("available_on <= ?",Date.today).order(available_on: :desc).limit(10)
    render :template => 'spree/products/quick_results'
  end

end