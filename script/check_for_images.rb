require File.expand_path('../../config/environment', __FILE__)


log_file_name = %Q{Checking-Images-#{Time.now.strftime("%m%d%y%I%M")}.log}
log_file =  %Q{#{Rails.root}/log/#{log_file_name}}
logger = Logger.new(log_file)
logger.info "Starting to Check images"
puts "Starting to Check images"


if Rails.env == 'staging'
  @local_site_path =   "/var/www/artspree3/"
else
  @local_site_path = "/home/louie/Dropbox/DEV/Artistic/sitesucker/www.artisticribbon.com/"
  #@local_site_path = "/tmp/t/"
end


r = NewItem.where("new_pbs_item <> 'master'").order(:ws_cat,:ws_subcat)


r.each do |rcpbs|

  begin
    src_image = rcpbs.item.gsub('/','-')
    src_image = %Q{#{@local_site_path}images/#{src_image}.jpg} rescue ''

    if !File.file?(src_image)
      #try removing
      itm_ar = rcpbs.item.gsub('/','-').split('-')
      itm_ar.last.gsub!(/\d+/,'')
      src_image = itm_ar.join('-')
      src_image = %Q{#{@local_site_path}images/#{src_image}.jpg} rescue ''
    end

    if !File.file?(src_image)
      src_image = get_replaced_inches_name(rcpbs)
      src_image = %Q{#{@local_site_path}images/#{src_image}.jpg} rescue ''
    end


    if !File.file?(src_image)
      src_image = rcpbs.item.gsub('/','-')
      src_image_bad = %Q{#{@local_site_path}images/#{src_image}} rescue ''
      src_image = %Q{#{@local_site_path}images/#{src_image}.jpg} rescue ''
      if File.file?(src_image_bad)
        File.rename(src_image_bad,src_image)
      end
    end

    if !File.file?(src_image)
      puts "No image for item #{rcpbs.item}"
      logger.info "No image for item #{rcpbs.item}"
    end
  rescue Exception => e
    puts "#{e.to_s}"
  end

end

BEGIN{

  def get_replaced_inches_name(rcpbs)
    width = rcpbs.item_prod_sub_cat
    width = width.split('/')
    first =  width.first.scan(/./).join('-')
    second = width.last
    new_width = %Q{#{first}-#{second}}
    rcpbs.item.gsub(rcpbs.item_prod_sub_cat,new_width)
  end

}