# Configure Spree Preferences
#
# Note: Initializing preferences available within the Admin will overwrite any changes that were made through the user interface when you restart.
#       If you would like users to be able to update a setting with the Admin it should NOT be set here.
#
# In order to initialize a setting do:
# config.setting_name = 'new value'
Spree.config do |config|
  # Example:
  # Uncomment to stop tracking inventory levels in the application
  config.track_inventory_levels = false
  #config.override_actionmailer_config = true
  config.searcher_class = Spree::Search::Solr
end

Spree.user_class = "Spree::User"
Spree::Config.set(logo: "artistic-logo-white.png")
Spree::Config.set(:products_per_page => 10)



# Use S3 for product images

attachment_config = {

    s3_credentials: {
        access_key_id:     ENV['AWS_ACCESS_KEY_ID'],
        secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
        bucket:            ENV['AWS_BUCKET']
    },

    storage:        :s3,
    s3_headers:     { "Cache-Control" => "max-age=315576000" },
    s3_protocol:    "http",
    bucket:         ENV['AWS_BUCKET'],
    url:            ":s3_domain_url",

    styles: {
        mini:     "48x48>",
        small:    "100x100>",
        product:  "240x240>",
        large:    "600x600>"
    },

    path:           "/:class/:id/:style/:basename.:extension",
    default_url:    "/:class/:id/:style/:basename.:extension",
    default_style:  "product"
}

attachment_config.each do |key, value|
  Spree::Image.attachment_definitions[:attachment][key.to_sym] = value
end


Spree::Taxon.class_eval do
  Spree::Taxon.attachment_definitions[:icon][:storage] = attachment_config[:storage]
  Spree::Taxon.attachment_definitions[:icon][:s3_credentials] = attachment_config[:s3_credentials]
  Spree::Taxon.attachment_definitions[:icon][:s3_headers] = attachment_config[:s3_headers]
  Spree::Taxon.attachment_definitions[:icon][:bucket] = attachment_config[:bucket]
end




puts "!!! #{Spree::Image.attachment_definitions[:attachment].inspect}"