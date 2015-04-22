require File.expand_path('../../config/environment', __FILE__)

# Add color option to All Tulle if it doesnt exsist


color_option = Spree::OptionType.find_by_name('color')

r = RcPbs.where("ws_cat like 'tulle%'")
#r = RcPbs.where("ws_subcat like 'tulle%' or ws_subcat like 'lacey%' or ws_subcat like 'geomesh%' or ws_subcat like 'glitter maze%' or ws_subcat like 'love foil%' ")

r.each do |rcpbs|

  variant = rcpbs.variant
  product = variant.product

  next if variant.has_color?

  #color
  colval = Spree::ProductOptionType.find_by_product_id_and_option_type_id(
      product.id,color_option.id
  )
  if colval.nil?
    colval = Spree::ProductOptionType.create(
        product_id:product.id,
        option_type_id: color_option.id
    )
  end

  product.save

  if  rcpbs.ws_color && ! rcpbs.ws_color.blank?

    sov1 = Spree::OptionValue.find_by_option_type_id_and_name(
        color_option.id,rcpbs.ws_color.titlecase
    )
    if sov1.nil?
      sov1 = Spree::OptionValue.create(
          option_type_id: color_option.id,
          presentation: rcpbs.ws_color.titlecase,
          name: rcpbs.ws_color.titlecase
      )
    end
    variant.option_values << sov1
    variant.save
  end

end