# pass site directory as an argument /home/louie/Dropbox/DEV/Artistic/sitesucker/www.artisticribbon.com
# script will attempt to find a file matching the name of the taxon and
# get the icon picture from the old site


require File.expand_path('../../config/environment', __FILE__)

log_file_name = %Q{taxon_images-#{Time.now.strftime("%m%d%y%I%M")}.log}
log_file =  %Q{#{Rails.root}/log/#{log_file_name}}
logger = Logger.new(log_file)
logger.info "Starting get Taxon images"

puts "Starting get Taxon images"


site_path = ARGV[0]
image_path = site_path+'/images'


Spree::Taxon.all.each do |t|
#Spree::Taxon.where(name: 'baby').each do |t|
  next if !(t.root.id == 1)
  srch_name = t.name.downcase.gsub(' ','*')

  files = Dir[%Q{#{site_path}/1-#{srch_name}*category*}]
  if files.count == 1
    f_path = files.first.chomp
    #puts "Processing file: #{f_path}..."
    uri = URI.parse(f_path)
    page=Nokogiri::HTML(open(f_path))



=begin
    alt_src = t.name.downcase.split(' ').first
    all_images = page.xpath("//img")
    im = []
    all_images.each do |i|
      next if i[:alt].blank?
      if i[:alt].downcase.include?(alt_src)
        im << i
        break
      end
    end
=end

    all_tables = page.xpath("//table")

    page1=Nokogiri::HTML(all_tables[2].to_s)
    im = page1.xpath('//img')


    if im && !im.empty?

      image_src = im.first[:src]
      if (!t.icon_file_name.nil? && t.icon_file_name == image_src.split('/').last)
        puts "alreay exists skipped"
        next
      elsif (!t.icon_file_name.nil? && !(t.icon_file_name == image_src.split('/').last))
        t.icon = nil
        t.save
      end


      if File.file?(%Q{#{site_path}/#{image_src[/images.*/i,0]}})
        t.icon = File.open(%Q{#{site_path}/#{image_src[/images.*/i,0]}})
        t.save
      else
        puts %Q{Cant find image: page #{f_path} image: #{image_src}}
        logger.info %Q{Cant find image: page #{f_path} image: #{image_src}}
      end

    else
      puts %Q{Cant get image for page #{f_path}}
      logger.info %Q{Cant get image for page #{f_path}}
    end

  else files.count > 1
    puts %Q{Too many pages found for #{t.name}}
    logger.info %Q{Too many pages found for #{t.name}}

  end
end