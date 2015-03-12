# load images based on path set as an argument
# image will have to be named #{sku}.#{ext}
# the directory of images is the first argument
# Call example  ruby script/load_images_from_path.rb #{dir}

require File.expand_path('../../config/environment', __FILE__)

images_path = ARGV[0]

puts images_path

Dir[%Q{#{images_path}/*}].each do |image_file|

  lookup = image_file.gsub(File.dirname(image_file),'').split('.')[0]
  lookup[0] = '' if lookup[0] == '/'


  v = Spree::Variant.find_by_sku(lookup)

  if v
     v.images <<  Spree::Image.create!(:attachment => File.open(image_file))
     v.save!
  end

end

