Spree::Order.class_eval do

  attr_accessor :allow_mailings

  # Called when checkout process is completed (@order.completed?) to update contact first and last name
  # if available.
  def update_contact
    attrs = {}
    attrs[:first_name] = billing_address.firstname.titleize unless billing_address.firstname.to_s.empty?
    attrs[:last_name] = billing_address.lastname.titleize unless billing_address.lastname.to_s.empty?
    unless attrs.empty?
      contact = Contact.find_by_email(email)
      contact.update(attrs) if contact
    end
  end
end