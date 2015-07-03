# Constant Contact wrapper model for CC API SDK
class Ccontact

  attr_accessor

  def initialize
    @oauth ||= ConstantContact::Auth::OAuth2.new()
    @api ||= ConstantContact::Api.new(Rails.application.secrets.cc_access_key, Rails.application.secrets.cc_token)
  end

  def find(id)
    @contact = @api.get_contact(id.to_s) rescue nil
  end

  # Adds list_id to ConstantContact contact object if not already a member
  def add_to_list(contact, list_id)
    contact.lists << ConstantContact::Components::ContactList.create(id: list_id.to_s) unless contact.lists.map(&:id).include?(list_id.to_s)
  end

  # Create a new constant contact from our contact object.  Must have email_address and lists as a minimum
  # email_address is single address string, lists is a single list id
  # If my_contact.cc is not nil, skip since this contact already exists at Constant Contact
  def add_contact(my_contact, params = {})
    return false if !my_contact.kind_of?(Contact) or my_contact.cc or my_contact.lists.nil?
    my_contact.lists = my_contact.lists.split(',') if !my_contact.lists.kind_of?(Array)
    contact = ConstantContact::Components::Contact.create(
        email_addresses: [email_address: my_contact.email_address],
        lists: my_contact.lists.map {|l| {id: l.to_s}},
        first_name: my_contact.first_name,
        last_name:  my_contact.last_name,
        company_name: my_contact.company_name)

    @api.add_contact(contact, params)
  end

  def get_contact_by_email(email)
    contacts = get_contacts(email: email)
    contacts.results[0]
  end

  def get_contacts(param = {})
    @api.get_contacts(param)
  end

  # Update attributes of contact and return updated object
  # Does not update email address
  # If my_contact.cc is nil, skip since contact does not exist.  In this case, call add_contact instead
  def update_contact(my_contact)
    return false if !my_contact.kind_of?(Contact) or !my_contact.cc
    contact = my_contact.cc
    contact.first_name =  my_contact.first_name
    contact.last_name  =   my_contact.last_name
    contact.company_name = my_contact.company_name
    add_to_list(contact, my_contact.lists)
    @api.update_contact(contact)
  end

  # Delete a contact from a list and return updated object
  # Passed:
  #   contact:  contact object (contact must exist)
  #   list_id:  id of list (integer or string)
  def delete_contact_from_list(contact, list_id)
    @api.delete_contact_from_list(contact.id.to_i, list_id.to_i) if in_list?(contact, list_id)
    find(contact.id)
  end

  def in_list?(contact, list_id)
    contact.lists.map(&:id).include?(list_id.to_s) rescue false
  end

  def get_lists(params = {})
    @api.get_lists(params)
  end

  def add_contact_to_list(contact, list_id)
    unless in_list?(contact, list_id)
      contact.lists << {id: list_id.to_s}
      contact = @api.update_contact(contact)
    end
    contact
  end

end