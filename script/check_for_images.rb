require File.expand_path('../../config/environment', __FILE__)


require %Q{#{Rails.root.to_s}/script/import_functions}


log_file_name = %Q{Checking-Images-#{Time.now.strftime("%m%d%y%I%M")}.log}
log_file =  %Q{#{Rails.root}/log/#{log_file_name}}
logger = Logger.new(log_file)
logger.info "Starting to Check images"
puts "Starting to Check images"


if Rails.env == 'staging'
  @local_site_path =   "/var/www/artspree3/"
else
  @local_site_path = "/home/louie/Dropbox/DEV/"
  #@local_site_path = "/tmp/t/"
end


r = NewItem.where("new_pbs_item <> 'master'").order(:ws_cat,:ws_subcat)


r.each do |rcpbs|

  begin

    @rcpbs = rcpbs
    @item_type = item_type(rcpbs) ||  ''
    src_image = get_image_path(rcpbs)


    if !File.file?(src_image)
      puts "No image for item #{rcpbs.item} #{rcpbs.brand}"
      logger.info "No image for item #{rcpbs.item} #{rcpbs.brand}"
    else
      #puts %Q{#{src_image}}
    end
  rescue Exception => e
    puts "#{e.to_s} item# #{@rcpbs.item} #{@rcpbs.brand}  "
  end

end

