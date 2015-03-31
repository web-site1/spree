# double face mixed with echo
require File.expand_path('../../config/environment', __FILE__)

taxon = Spree::Taxon.find(174)


r = RcPbs.where("ws_cat = 'Satin Ribbon' and ws_subcat = 'double face'")

r.each do |rcpbs|
  variant = rcpbs.variant
  product = variant.product

  existing_taxon_array = product.taxons.map{|t| t.id}

  if !existing_taxon_array.include?(taxon.id)
    product.taxons = []
    product.taxons << taxon
    product.save!
  end

end