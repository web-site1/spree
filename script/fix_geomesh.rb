require File.expand_path('../../config/environment', __FILE__)
                                 #165
geomesh_taxon = Spree::Taxon.find(165)

geo_prods = geomesh_taxon.products

prodnames = geo_prods.map{|p| p.name}.uniq


prodnames.each do |pn|

  prods = geo_prods.select{|p| p.name == pn}

  next if !(prods.count == 2)

  master_prod = prods[0]
  prod_to_delete = prods[1]

  variant_to_move = prod_to_delete.variants

  variant_to_move.each do |v|
    v.product_id = master_prod.id
    v.save!
  end

  prod_to_delete.delete

end