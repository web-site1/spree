require File.expand_path('../../config/environment', __FILE__)

flower_variants = []

flower_cat = Spree::Taxon.find_by_name('flowers')

flower_cat.products.each{|p|
  p.variants.each{|v|
    flower_variants << v
  }
}

flower_cat.children.each{|t|
  t.products.each{|p|
    p.variants.each{|v|
      flower_variants << v
    }
  }
}


putup_option = Spree::OptionType.find_by_name('ribbon-putup')

@option_value = Spree::OptionValue.find_by_option_type_id_and_name(
    putup_option.id,'1 dozen'
)

if @option_value.nil?
  @option_value = Spree::OptionValue.create(
      option_type_id: putup_option.id,
      presentation: '1 dozen',
      name: '1 dozen'
  )
end


ot = v.product.option_types

flower_variants.each do |v|
  p = v.product
  ot = p.option_types
  array_ot_id = ot.map{|o|o.id}
  if !array_ot_id.include?(putup_option.id)
    opval = Spree::ProductOptionType.create(
        product_id:p.id,
        option_type_id: v.id
    )
  end




end