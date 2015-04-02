Spree::User.class_eval do

  def disp_cust_number
    num = cust_number.sub(/^[0]*/,'').strip
  end

end