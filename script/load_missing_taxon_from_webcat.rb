require File.expand_path('../../config/environment', __FILE__)


site_path = ARGV[0]

log_file_name = %Q{taxon_images_from_webcat-#{Time.now.strftime("%m%d%y%I%M")}.log}
log_file =  %Q{#{Rails.root}/log/#{log_file_name}}
logger = Logger.new(log_file)


Spree::Taxon.where("icon_file_name is null").each do |t|
  next if !(t.root.id == 1)

  perm_array =  t.permalink.split('/')
  cat = ''
  subcat = ''
  if perm_array.count > 2
    if perm_array.count == 3
      # we are searching a top cat
      if perm_array[1] == 'tulle-and-trims' || perm_array[1] == 'chevron'
        cat = perm_array[1]
        subcat = perm_array[2]
      else
        cat = perm_array.last
        subcat = nil
      end
    else
      subcat = perm_array.last
      cat = perm_array[perm_array.index(subcat)-1]
      if subcat == 'metallic' && cat == 'ribbons'
        cat = 'metallic'
      end

    end

    if cat == 'dotted' && subcat
      cat = 'dot'
    end

    cat = cat.downcase.gsub('-and-','-&-')
    cat = cat.gsub('-','%')
    cat += '%'
    if cat == 'checks%&%plaids%'
      cat = 'check%&%plaid%'
    end
    where = "cat like '#{cat}' and subcat "

    if subcat
      subcat = subcat.downcase.gsub('-and-','-&-')
      subcat = subcat.gsub('-','%')
      subcat += '%'
      where += "like '#{subcat}'"
    else
      where += "is null"
    end

    wc = WebCat.where(where).first
    if wc
      file_exists = false
      if (wc.image_file && !wc.image_file.blank? &&
          !(wc.image_file == 'images/home.jpg'))
        if File.file?(%Q{#{site_path}/#{wc.image_file[/images.*/i,0]}})
          file_exists = true
          t.icon = File.open(%Q{#{site_path}/#{wc.image_file[/images.*/i,0]}})
          t.save
        end
        logger.info %Q{#{t.permalink} image: #{%Q{#{site_path}/#{wc.image_file[/images.*/i,0]}}} exsists: #{file_exists} }
        puts %Q{#{t.permalink} image: #{%Q{#{site_path}/#{wc.image_file[/images.*/i,0]}}} exsists: #{file_exists} }
      else
        logger.info %Q{#{t.permalink} No image available }
        puts %Q{#{t.permalink} No image available }
      end
    else
      logger.info %Q{#{t.permalink} no match where: #{where} }
      puts %Q{#{t.permalink} no match where: #{where} }
    end
  else
    puts "Type encountered!!!"
  end

end

