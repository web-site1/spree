# load images based on path set as an argument
# image will have to be named #{sku}.#{ext}
#

images_path = ARGV[0]

puts images_path

Dir[%Q{#{images_path}/*}].each do |image_file|

  lookup = image_file.gsub(File.dirname(image_file),'').split('.')[0]
  lookup[0] = '' if lookup[0] == '/'
  puts  lookup


end

