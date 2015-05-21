require File.expand_path('../../config/environment', __FILE__)

orig_folder = '/mnt/win/art/bad'
to_folder = '/home/louie/Dropbox/good'

MisSku.all.each do |i|
  if File.file?(%Q{#{orig_folder}/#{i.item}.jpg})
    FileUtils.cp(%Q{#{orig_folder}/#{i.item}.jpg}, %Q{#{to_folder}/#{i.new_pbs_desc_1}.jpg})
  end
end