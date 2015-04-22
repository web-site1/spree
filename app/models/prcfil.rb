class Prcfil < PbsData
  self.table_name = "#{db}.dbo.PRCFIL" + COMP_ID
  self.primary_key = :A4GLIdentity

  before_save :handle_numerics
  after_initialize :fill_from_template


  def handle_numerics
    self.prc_alt_item_no = Itmfil.item_no_as_stored(prc_alt_item_no) rescue nil
  end

  def self.delete_alt_unit(item_no)
    alt_unit_rec = find_by_prc_rec_typ_and_prc_key_flds('A',item_no)
    alt_unit_rec.destroy if alt_unit_rec
  end

  def self.save_alt_unit(itm)
    alt_unit_rec = find_by_prc_rec_typ_and_prc_key_flds('A',itm.item_no)
    alt_unit_rec.destroy if alt_unit_rec
    if itm.usr_def_qty_2 > 1
      new_record = new()
      new_record.assign_attributes(self.alt_unit_attrs(itm))
      new_record.save rescue nil
    end
  end

  def self.alt_unit_attrs(itm)
    conv_fact = (1.0 / itm.usr_def_qty_2).round(5)
    alt_unit_attrs = {
        prc_rec_typ: 'A,',
        prc_key_flds: Itmfil.item_no_as_stored(itm.item_no),
        prc_alt_item_no: itm.item_no,
        prc_alt_1_conv_fac: conv_fact,
        prc_alt_1_prc_cod: itm.item_prc_cod,
        prc_alt_1_prc_1: (conv_fact * itm.item_prc_1).round(2),
        prc_alt_1_prc_2: (conv_fact * itm.item_prc_2).round(2),
        prc_alt_1_prc_3: (conv_fact * itm.item_prc_3).round(2)
    }
  end

end
