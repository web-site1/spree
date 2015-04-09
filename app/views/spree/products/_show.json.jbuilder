	json.id product.id
	json.name product.name
	json.description product.description
	json.slug product.slug
	json.taxon product.taxons.first.name rescue ''
	json.taxon_parent product.taxons.first.parent.name rescue ''
	json.image product.images.first.attachment.url(:product) rescue ''
	json.variant_images_count product.variant_images.count
	json.colors product.colors.uniq
	json.widths product.widths.uniq.sort{ |a,b| compare_lengths(a,b) }
	json.diameters product.diameters.uniq.sort{ |a,b| compare_lengths(a,b) }
	json.totes product.tote_sizes.uniq.sort{ |a,b| a.to_f <=> b.to_f }.uniq
	json.putups product.ribbon_putups.uniq.sort{ |a,b| a.to_f <=> b.to_f }
	json.lengths product.lengths.uniq.sort{ |a,b| compare_lengths(a,b) }


	json.product_properties product.product_properties.includes(:property) do |property|
		json.property property.property.presentation
		json.value property.value
	end

	json.master do 
		json.id product.master.id
		json.sku product.master.sku
		json.price display_price(product.master)

		json.image product.master.images.first.attachment.url(:product) rescue ''
		json.image_mini product.master.images.first.attachment.url(:mini) rescue '' 
	end

	json.variants product.variants do |variant|
		json.id variant.id
		json.sku variant.sku
		json.price display_price(variant)
		json.image variant.images.first.attachment.url(:product) rescue ''
		json.image_mini variant.images.first.attachment.url(:mini) rescue '' 
		
		json.can_supply variant.can_supply?	
		json.width variant.option_value('width') || ''
		json.putup variant.option_value('ribbon-putup') || ''
		json.diameter variant.option_value('diameter') || ''
		json.length variant.option_value('length') || ''
		json.tote variant.option_value('tote-size') || ''
		json.color variant.option_value('color') || ''

	end