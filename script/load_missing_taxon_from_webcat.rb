require File.expand_path('../../config/environment', __FILE__)


Spree::Taxon.where("icon_file_name is null").each do |t|
  next if !(t.root.id == 1)

  perm_array =  t.permalink.split('/')
  cat = ''
  subcat = ''
  if perm_array.count > 2
    if perm_array.count == 3
      # we are searching a top cat
      cat = perm_array.last
      subcat = nil
    else
      subcat = perm_array.last
      cat = perm_array[perm_array.index(subcat)-1]
    end
    cat = cat.gsub('-','%')
    cat += '%'
    where = "cat like '#{cat}' and subcat "

    if subcat
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

