Spree::ProductsHelper.module_eval do
  def active_results_per_page(per_pg,num)
    if per_pg == num
      "active"
    end
  end

end