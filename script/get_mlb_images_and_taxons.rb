# create a taxon for sports item if it doesnt exist and assign the picture that corresponds to it
# Top taxon picture for MLB is on 1-MLB-ribbon-category.htm page and image has an alt
# attribute with the team name
# Then get image for the item which is on the product page

require '../config/environment'


local_html_path = '/home/louie/Dropbox/DEV/Artistic/sitesucker/www.artisticribbon.com/'


sport_items =
    Sport.where("ws_cat IN ('MLB Ribbon') ").order(:ws_cat,:ws_subcat,:ws_color) #.limit(10)

top_parent_taxon = Spree::Taxon.find_by_name('Categories')

log_file_name = %Q{mlb_image_scrape-#{Time.now.strftime("%m%d%y%I%M")}.log}
log_file =  %Q{#{Rails.root}/log/#{log_file_name}}
logger = Logger.new(log_file)
puts "Starting to Scrape"
logger.info "starting to scrape"

sport_items.each do |si|
  wi = si.web_item
  if wi.nil?
    puts "Missing web_item #{si.item}"
    logger.info "Missing web_item #{si.item}"
    next
  end

  #find cat taxon if exists
  cat_tax = Spree::Taxon.find_by_name(si.ws_cat.titleize)
  if cat_tax.nil?
    # we have a problem this should have been already added
    puts "Cat taxon missing ???  #{si.ws_cat.titleize}"
    logger.info "Cat taxon missing ???  #{si.ws_cat.titleize}"
    next
  end

  fname = %Q{#{local_html_path}#{wi.page}}

  if File.file?(fname)
    uri = URI.parse(fname)
    page=Nokogiri::HTML(open(fname))
  else
    puts "No Web_item page ???  #{si.item}"
    logger.info "No Web_item page ???  #{si.item}"
  end

  this_item_taxon =  Spree::Taxon.find_by_name_and_parent_id(si.ws_subcat.titleize,cat_tax.id)

  if this_item_taxon.nil?
    fname1 = %Q{#{local_html_path}1-MLB-ribbon-category.htm}
    uri = URI.parse(fname1)
    catpage=Nokogiri::HTML(open(fname1))

    all_images = catpage.xpath("//img")
    icon_image = ''

    all_images.each do |i|
      i_alt = i[:alt]
      if (i_alt =~ /.*#{si.ws_subcat}*/i)
        icon_image = i[:src]
        break
      end
    end

    #Need to create a taxon for this
    this_item_taxon = Spree::Taxon.create(
        parent_id: cat_tax.id,
        name: si.ws_subcat.titleize,
        taxonomy_id:top_parent_taxon.id,
        meta_description: wi.description.truncate(255,separator: ' ',omission: '...(cont)'),
        meta_title: wi.title.truncate(255,separator: ' '),
        meta_keywords: wi.keywords.truncate(255,separator: ' '),
        description: wi.top_description

    )

    if File.file?(%Q{#{local_html_path}#{icon_image[/images.*/i,0]}})
      this_item_taxon.icon = File.open(%Q{#{local_html_path}#{icon_image[/images.*/i,0]}})
      this_item_taxon.save
    else
      puts %Q{Cant find image for taxon #{this_item_taxon.name}}
      logger.info %Q{Cant find image for taxon #{this_item_taxon.name}}
    end

    puts %Q{Created #{this_item_taxon.name}}

  end

  item_image = ''


  all_images = page.xpath("//img")
  all_images.each do |i|
    i_alt = i[:alt]
    if (i_alt =~ /.*#{si.ws_subcat}*/i)
      item_image = i[:src]
      break
    end
  end

  if item_image.blank?
    #one more time diff noko obj
    page=Nokogiri::XML(open(fname))
    all_images = page.xpath("//img")
    all_images.each do |i|
      i_alt = i[:alt]
      if (i_alt =~ /.*#{si.ws_subcat}*/i)
        item_image = i[:src]
        break
      end
    end
  end


  if !item_image.blank?
    wi.update_attribute(:image_file,item_image)
  else
    puts %Q{Cant find image for item #{si.item}}
    logger.info %Q{Cant find image for taxon #{si.item}}
  end


end

