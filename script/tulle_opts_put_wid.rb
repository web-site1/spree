require File.expand_path('../../config/environment', __FILE__)


# Add options for specific Tulle subcats
# Tulle, Lacey, Geo Mesh, GeoMesh Cross, glitter maze, love foil
# options Width and putup

r = RcPbs.where("ws_subcat like 'tulle%' or ws_subcat like 'lacey%' or ws_subcat like 'geomesh%' or ws_subcat like 'glitter maze%' or ws_subcat like 'love foil%' ")


ribbon_putup_option = Spree::OptionType.find_by_name('ribbon-putup')
color_option = Spree::OptionType.find_by_name('width')


r.each do |rcpbs|
  variant = rcpbs.variant
  product = variant.product

  #putup
  putval = Spree::ProductOptionType.find_by_product_id_and_option_type_id(
      product.id,ribbon_putup_option.id
  )
  if putval.nil?
    putval = Spree::ProductOptionType.create(
        product_id:product.id,
        option_type_id: ribbon_putup_option.id
    )
  end

  #width
  widval = Spree::ProductOptionType.find_by_product_id_and_option_type_id(
      product.id,width_option.id
  )
  if widval.nil?
    widval = Spree::ProductOptionType.create(
        product_id:product.id,
        option_type_id: width_option.id
    )
  end

  product.save


  variant.option_values = []

  #putup
  if rcpbs.putup_pack && !rcpbs.putup_pack.blank?
    sov = Spree::OptionValue.find_by_option_type_id_and_name(
        ribbon_putup_option.id,rcpbs.putup_pack.strip.gsub(' ','-')
    )
    if sov.nil?
      sov = Spree::OptionValue.create(
          option_type_id: ribbon_putup_option.id,
          presentation: rcpbs.putup_pack,
          name: rcpbs.putup_pack.strip.gsub(' ','-')
      )
    end
    variant.option_values << sov
    variant.save
  end

  #width
  if rcpbs.width && !rcpbs.width.blank?

    sov1 = Spree::OptionValue.find_by_option_type_id_and_name(
        width_option.id,rcpbs.width
    )
    if sov1.nil?
      sov1 = Spree::OptionValue.create(
          option_type_id: width_option.id,
          presentation: rcpbs.width,
          name: rcpbs.width
      )
    end
    variant.option_values << sov1
    variant.save
  end

  #variant.save


end
