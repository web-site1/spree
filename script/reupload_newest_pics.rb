require File.expand_path('../../config/environment', __FILE__)

require %Q{#{Rails.root.to_s}/script/import_functions}

if Rails.env == 'staging'
  @local_site_path =   "/var/www/artspree3/"
else
  @local_site_path = "/home/louie/Dropbox/DEV/Artistic/sitesucker/www.artisticribbon.com/"
  #@local_site_path = "/tmp/t/"
end

itms = Spree::Product.where('id between 6601 and 6674').order(:id) #6674').order(:id)


itms.each do |product|

  variants = product.variants

  v = variants.first

  rcpbs = variants.first.new_item

  @item_type = item_type(rcpbs) ||  ''

  src_image = get_image_path(rcpbs)

  if File.file?(src_image)
    product.images.each{|i| i.delete}

    product.images <<  Spree::Image.create!(:attachment => File.open(src_image))
    product.save!
    puts %Q{uploaded product image #{product.name} id #{product.id}}

  else
    puts %Q{nf product image #{product.name}}
  end

  if (@item_type == 'Flower')

    variants.each do |v|
      rcpbs = v.new_item
      src_image = get_image_path(rcpbs)
      if File.file?(src_image)
        v.images.each{|i| i.delete}
        v.images <<  Spree::Image.create!(:attachment => File.open(src_image))
        v.save!
        puts %Q{uploaded variant product image #{product.name} id #{product.id}}
      else
        puts "Could not variant image #{v.sku}"
      end

    end

  end




end
