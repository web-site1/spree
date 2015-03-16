# create Taxons -
# - creates category and sub category entries in the taxon table
# - creates entries in old pages for taxon link with coresponding taxon
#
#
# Run from scripts directory  ruby
require '../config/environment'



log_file_name = %Q{Taxon_create-#{Time.now.strftime("%m%d%y%I%M")}.log}
log_file =  %Q{#{Rails.root}/log/#{log_file_name}}
logger = Logger.new(log_file)
logger.info "Starting to create taxons"
puts "Starting to create taxons"

#bwc = WebCat.all.select{|wc| wc.cat.nil? }

#bwc.each{|b| logger.info "Null category on ID #{b.id} }" }

# setup main categories
cats = WebCat.all.select{|wc| !wc.cat.nil? && wc.subcat.nil?}
#cats = WebCat.where(cat: "chevron")

created_ids = []

top_parent_taxon = Spree::Taxon.find_by_name('Categories')

cats.each do |c|
  name = get_formed_cat_name(c)

  # need to find by item type and name if possible
  mct = main_cat_type(c.cat,c.title)
  parent_id = top_parent_taxon.id

  if mct == "B" || mct == "R"
    main_cat_name = 'Ribbons'
    if mct == "B"
      main_cat_name = 'Bows'
    end
    main_cat_taxon = Spree::Taxon.find_by_parent_id_and_name(top_parent_taxon.id,main_cat_name)
    if main_cat_taxon
      taxon_main_cat =  Spree::Taxon.find_by_parent_id_and_name(main_cat_taxon.id,name)
    else
      taxon_main_cat = nil
    end
  else
    taxon_main_cat = Spree::Taxon.find_by_name(name)
  end


  # do not skip create subcats if exsists

  main_cat_exists = false

  if !taxon_main_cat.nil?
    main_cat_exists = true
    taxon = taxon_main_cat
    logger.info "Category Taxon #{name} exsists."
    puts "Category Taxon #{name} exsists."
  else

    if mct == "B" || mct == "R"
      if main_cat_taxon.nil?
        main_cat_taxon = Spree::Taxon.create(parent_id: parent_id,name: main_cat_name )
      end
      parent_id = main_cat_taxon.id
    end

    logger.info "Category Created Taxon #{name} created."
    puts "Category Created Taxon #{name} created."

    taxon = Spree::Taxon.create(
        parent_id: parent_id,
        name: name,
        taxonomy_id:top_parent_taxon.id,
        meta_description: c.description.truncate(255,separator: ' ',omission: '...(cont)'),
        meta_title: c.title.truncate(255,separator: ' '),
        meta_keywords: c.keywords.truncate(255,separator: ' '),
        description: c.top_description

    )

    OldPage.create(
        taxon_id: taxon.id,
        page: c.page

    )

  end


  created_ids << c.id


  subcats =  WebCat.where(cat: c.cat)

  subcats.each do |sc|


    existing_sub_cat =  Spree::Taxon.find_by_parent_id_and_name(taxon.id,sc.subcat)

    if existing_sub_cat.nil? && !(sc.subcat.nil? || sc.subcat.blank?)
      sub_taxon = Spree::Taxon.create(
          parent_id: taxon.id,
          name: sc.subcat.downcase.strip.titlecase ,
          taxonomy_id:top_parent_taxon.id,
          meta_description: sc.description.truncate(255,separator: ' ',omission: '...(cont)'),
          meta_title: sc.title.truncate(255,separator: ' '),
          meta_keywords: sc.keywords.truncate(255,separator: ' '),
          description: sc.top_description
      )

      OldPage.create(
          taxon_id: sub_taxon.id,
          page: sc.page
      )


      logger.info "Sub-Category Created Taxon #{sc.subcat} created for #{taxon.name}."
      puts "Sub-Category Created Taxon #{sc.subcat} created for #{taxon.name}."
    else
      logger.info "Skipping Sub-Category #{sc.subcat} already created with parent #{taxon.name}."
      puts "Skipping Sub-Category #{sc.subcat} already created with parent #{taxon.name}."
    end
    created_ids << sc.id
  end

end

error_web_cats = WebCat.where("id not in(#{created_ids.join(",")})")

logger.info "Total errors #{error_web_cats.count}"
puts "Total errors #{error_web_cats.count}"

error_web_cats.each do |e|
  message = error_detail(e)
  logger.info "Error id: #{e.id} message: #{message}"
  puts "Error id: #{e.id} message: #{message}"
end





BEGIN{
  def main_cat_type(cat,title)
    # determine if category is a main category or a child of another
    # Example baby ribbon is a child of ribbon but TULLE & TRIMS is a child
    # of categories.
    # For the moment using the word RIBBON to determine if a ribbon or Bow
    # for a bow
    #
    # will return "B" "R" or "S"
    parent_type = "S"

    if cat =~ /RIBBON/i
      parent_type = "R"
    elsif cat =~ /BOWS/i
      parent_type = "B"
    end

    case cat
      when cat =~ /RIBBON/i
        parent_type = "R"
      when cat =~ /BOWS/i
        parent_type = "B"
      else
        if title =~ /RIBBON/i
          parent_type = "R"
        elsif title =~ /BOWS/i
          parent_type = "B"
        end
    end

    return parent_type

  end

  def error_detail(webcat)
    # detail for errors found
    message = ""
    if webcat.cat.nil? || webcat.cat.blank?
        message = "Main Category is blank"
    elsif (Spree::Taxon.find_by_name(get_formed_cat_name(webcat)).nil?)
        message = "Main Category #{get_formed_cat_name(webcat)} does not exsist."
    else
        message = "Cannot determine error."
    end

  end

  def get_formed_cat_name(webcat)
    webcat.cat.downcase.gsub('ribbon','').gsub('bows','').strip.titlecase rescue ''
  end

}








