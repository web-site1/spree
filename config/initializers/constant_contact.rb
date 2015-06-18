ConstantContact::Util::Config.configure do |config|
  config[:auth][:api_key] = Rails.application.secrets.cc_access_key
  config[:auth][:api_secret] = Rails.application.secrets.cc_secret_access_key
  config[:auth][:redirect_uri] = 'https://www.artisticribbon.com'
end