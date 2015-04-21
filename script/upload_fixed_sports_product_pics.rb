require '../config/environment'


picfolder = '/home/louie/Dropbox/DEV/Artistic/pic2fix/'




itms = Sport.where("ws_cat IN('NFL Licensed Ribbon',  'Collegiate Licensed Ribbon') and ws_color <> '4 spool asmt'") #.limit(1)
vars = []
itms.each{|i| vars << Spree::Variant.find_by_item_no(i.new_pbs_item) }
p = vars.map{|v| v.product }.uniq


p.each do |i|


  image_path = %Q{#{picfolder}images/#{i.images.first.attachment_file_name}} rescue ''

  if File.exists?(image_path)
    i.images.each{|img| img.delete}
    i.images <<  Spree::Image.create!(:attachment => File.open(image_path))
    i.save!
    puts %Q{#{i.name} saved}
  end



end
