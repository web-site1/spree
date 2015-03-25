require File.expand_path('../../config/environment', __FILE__)


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
      puts %Q{#{t.permalink} image: #{wc.image_file} }


    else
      puts %Q{#{t.permalink} no match where: #{where} }
    end
  else
    puts "Type encountered!!!"
  end

end

