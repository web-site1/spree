class Contact
  include ActiveAttr::Model

  attribute :first_name
  attribute :last_name
  attribute :email_address
  attribute :company_name
  attribute :lists

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
    @ccapi = Ccontact.new()
    @cc = @ccapi.get_contact_by_email(attrs[:email_address])
    if @cc
      self.first_name = @cc.first_name
      self.last_name = @cc.last_name
      self.lists = @cc.lists.map(&:id) rescue []
    end
  end

  def in_list?(list_id)
    return false unless @cc
    @ccapi.in_list?(@cc, list_id)
  end

 def validate!

    errors.add(:email_addresses, "cannot be empty") unless email_addresses
    errors.add(:lists, "cannot be empty") unless lists
 end

  def save

  end

end
