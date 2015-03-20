class Stafil < PbsData
  self.table_name = "#{db}.dbo.STAFIL" + COMP_ID
  self.primary_key = :item_no
  before_save :handle_numerics, :handle_dup_fields
  after_initialize :fill_from_template

  belongs_to :itmfil, :primary_key => :item_no, :foreign_key => :item_no
  validates_presence_of :itmfil

end
