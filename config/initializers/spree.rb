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
  # config.track_inventory_levels = false
  #config.override_actionmailer_config = true
end

Spree.user_class = "Spree::User"
Spree::Config.set(logo: "artistic-logo-white.png")

# Use S3 for product images

# attachment_config = {
#
#     s3_credentials: {
#         access_key_id:     ENV['AWS_ACCESS_KEY_ID'],
#         secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
#         bucket:            "artspree-#{Rails.env}"
#     },
#
#     storage:        :s3,
#     s3_headers:     { "Cache-Control" => "max-age=31557600" },
#     s3_protocol:    "http",
#     bucket:         "artspree-#{Rails.env}",
#     url:            ":s3_domain_url",
#
#     styles: {
#         mini:     "48x48>",
#         small:    "100x100>",
#         product:  "240x240>",
#         large:    "600x600>"
#     },
#
#     path:           "/images/:class/:id/:style/:basename.:extension",
#     default_url:    "/images/:class/:id/:style/:basename.:extension",
#     default_style:  "product"
# }
#
# attachment_config.each do |key, value|
#   Spree::Image.attachment_definitions[:attachment][key.to_sym] = value
# end