class Itmfil < PbsData
  self.table_name = "#{db}.dbo.ITMFIL" + COMP_ID
  self.primary_key = :item_no
  before_save :handle_numerics, :handle_dup_fields, :handle_nulls
  after_save :save_alt_unit_info
  before_destroy :check_qtys
  after_destroy :delete_alt_unit_info
  after_initialize :fill_from_template

  has_many :stafils, :primary_key => :item_no, :foreign_key => :item_no, :dependent => :destroy

  def disp_item_no
    itm = item_no.sub(/^[0]*/,'').strip
  end

  def self.create_itmwork
    all.each do |i|
      Itmwork.create(i.attributes)
    end
  end

  def get_price
    item_prc_1
  end

private

  def handle_alt_unit
    self.alt_unit_1 = Unitfi.find_by_unit_desc(alt_unit_1).unit_cod rescue nil
  end

  def save_alt_unit_info
    Prcfil.save_alt_unit(self)
  end

  def delete_alt_unit_info
    Prcfil.delete_alt_unit(item_no)
  end

  def handle_nulls
    self.item_prod_cat      ||= ''
    self.item_prod_sub_cat  ||= ''
    self.item_prime_vend    ||= ''
  end

  def check_qtys
    unless qty_on_hand + qty_commitd + qty_on_ord + qty_on_bk_ord == 0
      self.errors[:base] << "Non-zero quantities exist: qty_on_hand + qty_commitd + qty_on_ord + qty_on_bk_ord != 0"
      return false
    end
  end

end
