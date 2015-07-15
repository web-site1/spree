Spree::User.class_eval do

  attr_accessor :allow_mailings

  def disp_cust_number
    num = cust_number.sub(/^[0]*/,'').strip
  end

  def subscribe
    contact = Contact.new(email_address: email, lists: MASTER_LIST_ID)
    contact.save
  end

end