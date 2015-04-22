require '../config/environment'


picfolder = '/home/louie/Dropbox/DEV/Artistic/pic2fix/'




itms = Sport.where("ws_cat IN('NFL Licensed Ribbon',  'Collegiate Licensed Ribbon') and ws_color <> '4 spool asmt'") #.limit(1)


itms.each do |i|

  wi = i.web_item
  v = Spree::Variant.find_by_item_no(i.new_pbs_item)
  image_path = %Q{#{picfolder}#{wi.image_file[/images.*/i,0]}}

  if File.exists?(image_path)
    v.images.each{|i| i.delete}
    v.images <<  Spree::Image.create!(:attachment => File.open(image_path))
    v.save!
    puts %Q{#{v.sku} saved}
  end



end
