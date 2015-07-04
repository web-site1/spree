class Contact
  include ActiveAttr::Model

  attribute :id
  attribute :first_name
  attribute :last_name
  attribute :email_address
  attribute :company_name
  attribute :lists
  attribute :cc

  validates_presence_of :email_address, :lists
  validates_format_of :email, :with => /\A[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}\z/i

  # Constant Contact contact object fields:

  # attr_accessor :id, :status, :first_name, :middle_name, :last_name, :confirmed, :email_addresses,
  #               :prefix_name, :job_title, :addresses, :company_name, :home_phone,
  #               :work_phone, :cell_phone, :fax, :custom_fields, :lists,
  #               :source_details, :notes, :source

  # The following are arrays of hashes (though email_addresses can only contain a single element)
  # 'email_addresses' :id, :status, :confirm_status, :opt_in_source, :opt_in_date, :opt_out_date, :email_address (required)
  # 'addresses'       :id, :line1, :line2, :line3, :city, :address_type, :state_code, :country_code, :postal_code, :sub_postal_code
  # 'notes'           :id, :note, :created_date, :modified_date
  # 'custom_fields'   :name, :value
  # 'lists'           :id (required), :name, :status, :contact_count

  # To save a record, email_addresses and lists are required

 # include ActiveModel::Model
 # include ActiveModel::Naming


  # minimum attributes to initialize this object:  email_address
  def initialize(attrs)
    super
    @ccapi = Ccontact.new()
  end

  def persisted?
    cc
  end

  def find
    @ccapi.find(id)
  end

  def find_by_email
    return nil if email_address.to_s.empty?
    @ccapi.get_contact_by_email(email_address)
  end

  # Return a Contact object if found at constant contact.  Otherwise, nil.
  def self.find_by_email(email = nil)
    return nil unless email
    contact = Contact.new(email_address: email)
    contact.cc = contact.find_by_email
    return nil unless contact.cc
    contact.ccontact_to_contact
    contact
  end

  def self.find(id)
    contact = Contact.new(id: id)
    contact.cc = contact.find
    return nil unless contact.cc
    contact.ccontact_to_contact
    contact
  end

  def ccontact_to_contact
    self.id = cc.id
    self.email_address = cc.email_addresses.first.email_address
    self.first_name = cc.first_name
    self.last_name = cc.last_name
    self.company_name = cc.company_name
    self.lists = cc.lists.map(&:id) rescue []
  end

  def in_list?(list_id)
    return false unless cc
    @ccapi.in_list?(cc, list_id)

  end

  def unsubscribe(list_id)
    @ccapi.delete_contact_from_list(cc, list_id)
    self.cc = find
    ccontact_to_contact
    true
  end

  def validate!
    errors.add(:email_address, "cannot be empty") unless (email_address and !email_address.empty?)
    errors.add(:lists, "cannot be empty") unless lists
  end

  def update(attrs)
    assign_attributes(attrs)
    save
  end

  def save
    validate!
    unless errors.any?
      begin
        self.cc = @ccapi.get_contact_by_email(email_address) unless email_address.to_s.empty?
        if !cc
          self.cc = @ccapi.add_contact(self)
        else
          self.cc = @ccapi.update_contact(self)
        end
        ccontact_to_contact
      rescue Exception => e
        errors.add(:email_address, e.to_s)
        return false
      end
    end
  end

end
