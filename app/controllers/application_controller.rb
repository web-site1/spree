class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  #before_filter :top_search_vars

=begin
  def top_search_vars

    color_prop = Spree::Property.find_by_name('color')
    @color_array = Spree::ProductProperty.product_values(color_prop.id).map{|v| v.value}.uniq

    type_prop = Spree::Property.find_by_name('type')
    @type_array = Spree::ProductProperty.product_values(type_prop.id).map{|v| v.value}.uniq

    width_option = Spree::OptionType.find_by_name('width')
    @width_array = Spree::OptionValue.option_names(width_option.id).map{|v| v.presentation}.uniq

    put_up_option = Spree::OptionType.find_by_name('ribbon-putup')
    @put_up_array = Spree::OptionValue.option_names(put_up_option.id).map{|v| v.presentation}.uniq


    @pattern_array = Spree::Taxon.where(depth: 3).map{|p| p.name}.uniq

  end
=end

end
