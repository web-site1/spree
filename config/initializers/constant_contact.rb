ConstantContact::Util::Config.configure do |config|
  config[:auth][:api_key] = Rails.application.secrets.cc_access_key
  config[:auth][:api_secret] = Rails.application.secrets.cc_secret_access_key
  config[:auth][:redirect_uri] = 'https://www.artisticribbon.com'
end

ConstantContact::Components::Contact.class_eval do

  class_attribute :email_address, :list

  def in_list?(list_id)
    Ccontact.new().in_list?(self, list_id)
  end

  def update
    Ccontact.new().update_contact(self)
  end

end
