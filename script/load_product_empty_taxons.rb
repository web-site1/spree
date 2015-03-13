# Check products for empty taxons and see if we can add one with logic
# used in create items

require File.expand_path('../../config/environment', __FILE__)

log_file_name = %Q{redo_empty_taxons-#{Time.now.strftime("%m%d%y%I%M")}.log}
log_file =  %Q{#{Rails.root}/log/#{log_file_name}}
logger = Logger.new(log_file)

Spree::Product.all.each do |p|
  if p.taxons.empty?
    logger.info %Q{Product id #{p.id} has empty Taxon. Attempting Add}
    puts %Q{Product id #{p.id} has empty Taxon. Attempting Add}
    rcpbs = RcPbs.where(new_pbs_item: p.variants.first.item_no) rescue nil
    if (rcpbs.nil? || rcpbs.empty?)
      logger.info %Q{Product id #{p.id} No Pbs Item no}
      puts %Q{Product id #{p.id} No Pbs Item no}
    else
      rcpbs = rcpbs.first
      item_type = item_type(rcpbs) ||  ''
      srchtype = (item_type.blank?) ? item_type.strip : %Q{#{item_type.downcase.strip}s}
      srchtype = srchtype.gsub(' ','%')
      srchtype = srchtype.gsub('&','')
      srchtype = srchtype.gsub('trimss','trims')
      maincat = get_formed_cat_name(rcpbs.ws_cat).titlecase.gsub(' ','%')
      maincat = maincat.gsub('&','')

      subcat = rcpbs.ws_subcat.downcase.strip.titlecase.gsub(' ','%')
      subcat = subcat.gsub('&','')

      perma_srch = %Q{'%#{srchtype}%#{maincat}%#{subcat}%'}

      if srchtype.upcase == maincat.upcase
        maincat = '%'
      end


      taxonrec = Spree::Taxon.where("permalink like #{perma_srch} ").first

      if item_type == 'Flower'


      end

      if ( taxonrec.nil?)
        logger.info %Q{Product id #{p.id} No taxon found for search #{perma_srch}}
        puts %Q{Product id #{p.id} No taxon found for search #{perma_srch}}
      else
        p.taxons << taxonrec
        p.save!
      end


    end
  end
end


BEGIN{
  # functions
  def item_type(pbs_item_rec)
    itemtype = ''
    case
      when pbs_item_rec.item.strip[0..1].downcase == 'cq'
        itemtype = "Flower"
      when pbs_item_rec.ws_cat =~ /ribbon/i
        itemtype = "Ribbon"
      when pbs_item_rec.ws_cat =~ /bow/i
        itemtype =  "Bow"
      when  pbs_item_rec.desc =~ /ribbon/i
        itemtype = "Ribbon"
      when pbs_item_rec.desc =~ /bow/i
        itemtype =  "Bow"
      when  pbs_item_rec.desc =~ /flower/i
        itemtype = "Flower"
      when pbs_item_rec.ws_cat =~ /flowers/i
        itemtype =  "Flower"
      else
        itemtype = pbs_item_rec.ws_cat.strip.titlecase
    end
  end

  def get_formed_cat_name(webcat)
    webcat.downcase.gsub('ribbon','').gsub('bows','').gsub('flowers','').strip.titlecase rescue ''
  end


}
