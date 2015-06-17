require File.expand_path('../../config/environment', __FILE__)

images_path = ARGV[0]

puts images_path

Dir[%Q{#{images_path}/*}].each do |image_file|


=begin
  lookup = image_file.gsub(File.dirname(image_file),'').split('.')[0]
  lookup[0] = '' if lookup[0] == '/'
=end

  lookup = File.basename(image_file,File.extname(image_file))
  v = Spree::Variant.find_by_sku(lookup)
  v = Spree::Variant.find_by_sku(lookup.gsub('CQA-17_SK','CQA-17/SK')) if v.nil?
  v = Spree::Variant.find_by_sku(lookup.gsub('CQA-17_SK-lt.-purple_moss','CQA-17/SK-lt.-purple/moss')) if v.nil?
  if !v
    puts "No picture found! #{lookup}"
  else
    p = v.product
    if p.images.empty?
      p.images <<  Spree::Image.create!(:attachment => File.open(%Q{#{image_file}}))
      p.save!
    end

    if v.images.empty?
        v.images <<  Spree::Image.create!(:attachment => File.open(%Q{#{image_file}}))
        v.save!
        puts "Image loaded #{v.sku}!"
    end

  end
end