# double face mixed with echo
require File.expand_path('../../config/environment', __FILE__)

taxon = Spree::Taxon.find(417)


r = RcPbs.where("ws_subcat = 'collegiate'")

r.each do |rcpbs|
  variant = rcpbs.variant rescue nil
  if variant.nil?
    puts "problem #{rcpbs.id}"
    next
  end

  product = variant.product rescue nil

  if product.nil?
    puts "problem #{rcpbs.id}"
    next
  end


  existing_taxon_array = product.taxons.map{|t| t.id}

  if !existing_taxon_array.include?(taxon.id)
    product.taxons = []
    product.taxons << taxon
    product.save!
  end

end