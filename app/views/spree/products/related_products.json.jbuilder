json.products @related_products do |related_product|
	json.name related_product.name
	json.image related_product.images.first.attachment.url()
	json.url "/products/"+related_product.slug
end