class NewItem < ActiveRecord::Base

  #self.table_name = 'minions'

  before_validation :strip_quotes, :set_new_pbs_item

  def strip_quotes
    self.description = description.remove_quotes if description.to_s[0] == '"'
    self.new_pbs_desc_2 = new_pbs_desc_2.remove_quotes if new_pbs_desc_2.to_s[0] == '"'
    self.new_pbs_desc_3 = new_pbs_desc_3.remove_quotes if new_pbs_desc_3.to_s[0] == '"'
    true
  end

  def set_new_pbs_item
    if new_pbs_item.to_s.empty? and new_pbs_item != 'MASTER'
      v = Vendor.find_by_brand(brand)
      if v
        if brand == 'OFFRAY' and !offray_sku.to_s.empty?
          self.new_pbs_item = v.prefix + '-' + offray_sku
        elsif brand == 'OFFRAY' and offray_sku.to_s.empty?
          self.new_pbs_item = next_offray_item_no(v)
        else
          self.new_pbs_item = next_non_offray_item_no(v)
        end
        self.item_prime_vend = v.vend_no.strip.number? ? v.vend_no.strip.rjust(6, '0') : v.vend_no
        true
      end
    end
  end

  def next_offray_item_no(vendor)
    max_new_pbs_item = max_item_for_vendor(vendor)
    last_seq = max_new_pbs_item.to_numeric rescue '0'
    next_no = vendor.prefix + '-' + 'A' + (last_seq.to_i + 1).to_s.rjust(5, '0')
    vendor.update_attribute(:last_item_no, next_no)
    next_no
  end

  def next_non_offray_item_no(vendor)
    max_new_pbs_item = max_item_for_vendor(vendor)
    last_seq = max_new_pbs_item.to_numeric rescue '0'
    next_no = vendor.prefix + '-' + (last_seq.to_i + 10).to_s.rjust(6, '0')
    vendor.update_attribute(:last_item_no, next_no)
    next_no
  end

  def max_item_for_vendor(vendor)
    return vendor.last_item_no unless vendor.last_item_no.to_s.empty?
    Itmfil.select(:item_no).where("item_no like '#{vendor.prefix}-%'").where(["item_desc_1 <> ?", new_pbs_desc_1]).order("item_no desc").first.item_no rescue "0"
  end

  def self.set_calculated_fields
    all.each do |pw|
      pw.save
    end
  end

end