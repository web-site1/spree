require '../config/environment'


picfolder = '/home/louie/Dropbox/DEV/Artistic/pic2fix/'


Dir[%Q{#{picfolder }*}].each do |image_file|
 fname = image_file.split("/").last
 system("convert -crop '300x' #{image_file} #{picfolder}tmp/newfile.jpg")
 system("cp #{picfolder}tmp/newfile-0.jpg #{picfolder}fixed/#{fname}")
end


=begin
itms = Sport.where("ws_cat IN('NFL Licensed Ribbon',  'Collegiate Licensed Ribbon') and ws_color <> '4 spool asmt'")


itms.each do |i|

  wi = i.web_item

  image_path = %Q{#{@local_site_path}#{wi.image_file[/images.*/i,0]}}

  FileUtils.cp(image_path , newfolder)

end=end
