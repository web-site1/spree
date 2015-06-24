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

  def add_to_list(list_id)
    @ccontact.lists << {id: list_id.to_s} unless @ccontact.lists.map(&:id).include?(list_id.to_s)
  end

  def add_contact(contact, params = {})
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
  def update_contact(contact)
    @api.update_contact(contact)
    find(contact.id)
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
    contact.lists.map(&:id).include?(list_id.to_s)
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