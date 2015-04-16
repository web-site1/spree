require File.expand_path('../../config/environment', __FILE__)

flower_variants = []

=begin
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
=end

putup_option = Spree::OptionType.find_by_name('ribbon-putup')

option_value = Spree::OptionValue.find_by_option_type_id_and_name(
    putup_option.id,'1-Dozen'
)

if option_value.nil?
  option_value = Spree::OptionValue.create(
      option_type_id: putup_option.id,
      presentation: '1 dozen',
      name: '1-Dozen'
  )
end

prod = Spree::Product.find_by_name('Artificial Flowers (CQA-102)')

prod.variants.each do |v|
  flower_variants << v
end


flower_variants.each do |v|
  p = v.product
  ot = p.option_types
  array_of_options = ot.map{|ot|ot.name}

  if !array_of_options.include?(putup_option.name)
    p.option_types << putup_option
    p.save!
  end


  opval = Spree::ProductOptionType.find_by_product_id_and_option_type_id(
      p.id,putup_option.id
  )

  if opval.nil?
    opval = Spree::ProductOptionType.create(
        product_id:p.id,
        option_type_id: putup_option.id
    )
  end


  opt_vals = v.option_values

  to_keep = []
  opt_vals.each{|ov|
    if !(ov.option_type.name  == putup_option.name)
      to_keep << ov
    end
  }

  to_keep << option_value
  v.option_values = []
  to_keep.each{|val| v.option_values << val  }

  v.save!

  puts %Q{putup added #{p.name} #{v.sku}}

end