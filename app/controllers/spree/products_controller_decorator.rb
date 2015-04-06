Spree::ProductsController.class_eval do

  def show_new_arrivals
    @quick_title = "New Arrivals"
    @products = Spree::Product.where("available_on <= ?",Date.today).order(available_on: :desc).limit(10)
    render :template => 'spree/products/quick_results'
  end

  def show_new_flower_arrivals
    @quick_title = "New Flowers"
    all_flowers = []
    @flower_taxon = Spree::Taxon.find_by_name('flowers')
    @flower_taxon.children.each{|c|
      c.products.each{|p| all_flowers << p}
    }
    all_flowers.sort!{|a,b| b[:available_on] <=> a[:available_on] rescue []}
    @products = all_flowers[0..9]
    #@products = Spree::Product.where("available_on <= ?",Date.today).order(available_on: :desc).limit(10)
    render :template => 'spree/products/quick_results'
  end


end