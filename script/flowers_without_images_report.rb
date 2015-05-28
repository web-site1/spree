require File.expand_path('../../config/environment', __FILE__)
require 'csv'

csv_file =  %Q{#{Rails.root}/log/flowers_no_images.csv}
no_images = 0


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

CSV.open(csv_file, "wb") do |csv|
  csv << ['sku','name','color']

  flower_variants.each do |f|
    if f.images.empty?
      csv << [f.sku,f.product.name,f.variant_color]
      no_images += 1
      puts "no image #{f.sku}"
    end
  end
end
puts "Total #{no_images} flowers with no image"