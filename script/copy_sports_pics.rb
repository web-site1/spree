require '../config/environment'


newfolder = '/home/louie/pic2fix'

@local_site_path = "/home/louie/Dropbox/DEV/Artistic/sitesucker/www.artisticribbon.com/"

itms = Sport.where("ws_cat IN('NFL Licensed Ribbon',  'Collegiate Licensed Ribbon') and ws_color <> '4 spool asmt'")


itms.each do |i|

  wi = i.web_item

  image_path = %Q{#{@local_site_path}#{wi.image_file[/images.*/i,0]}}

  FileUtils.cp(image_path , newfolder)

end