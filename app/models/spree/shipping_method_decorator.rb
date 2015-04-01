Spree::ShippingMethod.class_eval do

  def sack_range
    rtn_rng = (0..500000)
    begin
      admin_name_array = self.admin_name.split("_")
      len = admin_name_array.length
      range_array = admin_name_array[len-2..len].map{|t| t.to_f}
      rtn_rng = (range_array.first..range_array.last)
    rescue Exception => e
      puts e.to_s
    end
    return rtn_rng
  end

end