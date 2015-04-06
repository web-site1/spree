Spree::AppConfiguration.class_eval do
  preference :mails_from, :string, default: 'spree@example.com'
end