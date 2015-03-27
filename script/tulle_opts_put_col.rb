require File.expand_path('../../config/environment', __FILE__)


# Add options for specific Tulle subcats
# Cord on a spool
# options color and putup

r = RcPbs.where("ws_subcat like 'cord%'")


ribbon_putup_option = Spree::OptionType.find_by_name('ribbon-putup')
color_option = Spree::OptionType.find_by_name('color')


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

  #color_option
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

  #variant.save


end
