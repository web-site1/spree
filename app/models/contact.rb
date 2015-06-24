class Contact < ConstantContact::Components::Contact
  # Defined in parent
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

 include ActiveModel::Model


 def self.find(id)
   cc = Ccontact.new().find(id)
   cc.email_address = cc.email_addresses.first.email_address
   cc
 end

 def self.find_by_email(email)
   Ccontact.new().get_contact_by_email(email)
 end

 def self.column_names
   [ :id, :status, :first_name, :middle_name, :last_name, :confirmed, :email_addresses,
                 :prefix_name, :job_title, :addresses, :company_name, :home_phone,
                 :work_phone, :cell_phone, :fax, :custom_fields, :lists,
                 :source_details, :notes, :source ]
 end

 def validate!

    errors.add(:email_addresses, "cannot be empty") unless email_addresses
    errors.add(:lists, "cannot be empty") unless lists
 end

  def save

  end

end
