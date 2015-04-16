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

    src_image = get_image_path(rcpbs)
    @rcpbs = rcpbs

    if !File.file?(src_image)
      puts "No image for item #{rcpbs.item} #{rcpbs.brand}"
      logger.info "No image for item #{rcpbs.item} #{rcpbs.brand}"
    end
  rescue Exception => e
    puts "#{e.to_s} item# #{@rcpbs.item} #{@rcpbs.brand}  "
  end

end

BEGIN{

  WIDTH_CODES = {
      '1/4' => '001',
      '1/2' => '002',
      '5/8' => '003',
      '5/8' => '005',
      '11/2'=> '009',
      '21/2'=> '040',
      '3/8' => '105',
      '6'   => '300'
  }



  def get_replaced_inches_name(rcpbs,find_by_des = false)
    width = rcpbs.item_prod_sub_cat
    width = width.split('/')
    first =  width.first.scan(/./).join('-')
    second = width.last
    new_width = %Q{#{first}-#{second}}
    if find_by_des
      rcpbs.new_pbs_desc_1.gsub(rcpbs.item_prod_sub_cat,new_width)
    else
      rcpbs.item.gsub(rcpbs.item_prod_sub_cat,new_width)
    end

  end

  def get_image_path(rcpbs)
    src_image = rcpbs.item.gsub('/','-')
    src_image = %Q{#{@local_site_path}images/#{src_image.strip.gsub(' ','-')}.jpg} rescue ''

    if !File.file?(src_image)
      #try removing
      itm_ar = rcpbs.item.gsub('/','-').split('-')
      itm_ar.last.gsub!(/\d+/,'')
      src_image = itm_ar.join('-')
      src_image = %Q{#{@local_site_path}images/#{src_image.strip.gsub(' ','-')}.jpg} rescue ''
    end

    if !File.file?(src_image)
      src_image = rcpbs.item.gsub('/','-').upcase
      src_image = %Q{#{@local_site_path}images/#{src_image.strip.gsub(' ','-')}.jpg} rescue ''
    end

    if !File.file?(src_image)
      src_image = get_replaced_inches_name(rcpbs)
      src_image = %Q{#{@local_site_path}images/#{src_image.strip.gsub(' ','-')}.jpg} rescue ''
    end

    if !File.file?(src_image)
      src_image = rcpbs.item.gsub('/','-')
      src_image_bad = %Q{#{@local_site_path}images/#{src_image.strip.gsub(' ','-')}} rescue ''
      src_image = %Q{#{@local_site_path}images/#{src_image.strip.gsub(' ','-')}.jpg} rescue ''
      if File.file?(src_image_bad)
        File.rename(src_image_bad,src_image)
      end
    end

    if !File.file?(src_image)
      #try Flowers
      color = rcpbs.ws_color.downcase
      src_image = rcpbs.item.gsub(rcpbs.ws_color.strip,color.strip.gsub(' ','-'))
      src_image = %Q{#{@local_site_path}images/#{src_image.strip.gsub(' ','-')}.jpg} rescue ''
    end



    if !File.file?(src_image)
      replaced_item = get_replaced_inches_name(rcpbs)
      src_image = replaced_item.sub(/-/,'')
      src_image = %Q{#{@local_site_path}images/#{src_image.strip.gsub(' ','-')}.jpg} rescue ''
    end

    if !File.file?(src_image)
      src_image = rcpbs.new_pbs_desc_1.gsub('/','-')
      src_image = %Q{#{@local_site_path}images/#{src_image.strip.gsub(' ','-')}.jpg} rescue ''

      if !File.file?(src_image)
        #try removing
        itm_ar = rcpbs.new_pbs_desc_1.gsub('/','-').split('-')
        itm_ar.last.gsub!(/\d+/,'')
        src_image = itm_ar.join('-')
        src_image = %Q{#{@local_site_path}images/#{src_image.strip.gsub(' ','-')}.jpg} rescue ''
      end

      if !File.file?(src_image)
        src_image = get_replaced_inches_name(rcpbs,true)
        src_image = %Q{#{@local_site_path}images/#{src_image.strip.gsub(' ','-')}.jpg} rescue ''
      end

      if !File.file?(src_image)
        src_image = rcpbs.new_pbs_desc_1.gsub('/','-')
        src_image_bad = %Q{#{@local_site_path}images/#{src_image.strip.gsub(' ','-')}} rescue ''
        src_image = %Q{#{@local_site_path}images/#{src_image.strip.gsub(' ','-')}.jpg} rescue ''
        if File.file?(src_image_bad)
          File.rename(src_image_bad,src_image)
        end
      end

      if !File.file?(src_image)
        #try Flowers
        color = rcpbs.ws_color.downcase
        src_image = rcpbs.new_pbs_desc_1.gsub(rcpbs.ws_color.strip,color.strip)
        src_image = %Q{#{@local_site_path}images/#{src_image.strip.gsub(' ','-')}.jpg} rescue ''
      end

      if !File.file?(src_image)
        replaced_item = get_replaced_inches_name(rcpbs,true)
        src_image = replaced_item.sub(/-/,'')
        src_image = %Q{#{@local_site_path}images/#{src_image.strip.gsub(' ','-')}.jpg} rescue ''
      end
    end

    if !File.file?(src_image)
      src_image = get_mapped_code_item(rcpbs)
      if src_image.class == Array
        f = src_image.first
        src_image = %Q{#{@local_site_path}images/#{f.strip.gsub(' ','-')}.jpg} rescue ''
        if !File.file?(src_image)
          f = src_image.last
          src_image = %Q{#{@local_site_path}images/#{f.strip.gsub(' ','-')}.jpg} rescue ''
        end
      else
        src_image = %Q{#{@local_site_path}images/#{src_image.strip.gsub(' ','-')}.jpg} rescue ''
      end

    end



    return src_image
  end


  def get_mapped_code_item(rcpbs)
    ba = rcpbs.new_pbs_desc_1.split('-')

    is_array_rtn = false
    # '5/8' => '005'
    if ba[1] == '5/8'
      is_array_rtn = true
    end

    if is_array_rtn
      ["#{ba[0]}-003-#{ba[3]}-#{ba[2]}","#{ba[0]}-005-#{ba[3]}-#{ba[2]}"]
    else
      "#{ba[0]}-#{WIDTH_CODES[ba[1]]}-#{ba[3]}-#{ba[2]}"
    end
  end


}