# create Taxons -
# - creates category and sub category entries in the taxon table
# - creates entries in old pages for taxon link with coresponding taxon
#
#
# Run from scripts directory  ruby
require '../config/environment'



cat_added = 0
subcat_addes = 0

log_file_name = %Q{Taxon_create-#{Time.now.strftime("%m%d%y%I%M")}.log}
log_file =  %Q{#{Rails.root}/log/#{log_file_name}}
logger = Logger.new(log_file)
logger.info "create taxons Start"
bwc = WebCat.all.select{|wc| wc.cat.nil? }

bwc.each{|b| logger.info "Null category on ID #{b.id} }" }



# setup main categories
cats = WebCat.all.select{|wc| !wc.cat.nil? && wc.subcat.nil?}

cats.each do |c|
  name = c.cat.downcase.gsub('ribbon','').gsub('bows','').strip.titlecase

  # skip if exsists
  next if !Spree::Taxon.find_by_name(name).nil?

  mct = main_cat_type(c.cat,c.title)

  top_parent_taxon = Spree::Taxon.find_by_name('Categories')

  parent_id = top_parent_taxon.id

  if mct == "B" || mct == "R"
    main_cat_name = 'Ribbons'
    if mct == "B"
      main_cat_name = 'Bows'
    end
    main_cat_taxon = Spree::Taxon.find_by_name(main_cat_name)
    if main_cat_taxon.nil?
      main_cat_taxon = Spree::Taxon.create(parent_id: parent_id,name: main_cat_name )
    end
    parent_id = main_cat_taxon.id
  end

  taxon = Spree::Taxon.create(
      parent_id: parent_id,
      name: name,
  )

  OldPage.create(
      taxon_id: taxon.id,
      page: c.page
  )

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

    if cat =~ /RIBBON/
      parent_type = "R"
    elsif cat =~ /BOWS/
      parent_type = "B"
    end

    case cat
      when cat =~ /RIBBON/
        parent_type = "R"
      when cat =~ /BOWS/
        parent_type = "B"
      else
        if title =~ /RIBBON/
          parent_type = "R"
        elsif title =~ /BOWS/
          parent_type = "B"
        end
    end

    return parent_type

  end

}








