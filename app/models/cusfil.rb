class Cusfil < PbsData
  self.table_name = "#{db}.dbo.CUSFIL" + COMP_ID
  self.primary_key = :cust_no
  before_save :handle_numerics, :handle_dup_fields, :handle_nulls
  after_initialize :fill_from_template

  def handle_numerics
    self.cust_no = Cusfil.cust_no_as_stored(cust_no) rescue nil
  end


  def handle_dup_fields
    # set all item_no_n fields = item_no
    attributes.keys.select{|k| k.match(/cust_no_\d+/)}.each {|f| self[f] = cust_no}
  end

  def self.cust_no_as_stored(str)
    str = str.number? ? str.rjust(12, '0') : str
  end


private

  def handle_nulls
    # self.item_prod_cat      ||= ''
    # self.item_prod_sub_cat  ||= ''
    # self.item_prime_vend    ||= ''
    #
  end

end
