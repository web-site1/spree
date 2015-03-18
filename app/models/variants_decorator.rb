Spree::Variant.class_eval do

  has_one :rcpbs,class_name: RcPbs ,foreign_key: :new_pbs_item, primary_key: :item_no
  has_one :itmfil, foreign_key: :item_no, primary_key: :item_no

  Spree::OptionType.all.map{|p| p.name.downcase.gsub(' ','_').gsub('-','9')}.reject{|vn| vn == 'color'|| vn == 'width'}.each do |p|
    define_method(%Q{variant_#{p}}) do
      self.option_values.select{|ov| ov.option_type.name.downcase == p.gsub('_',' ').gsub('9','-')}.first.name rescue ''
    end
  end

  def variant_width
    self.option_values.select{|ov| ov.option_type.name.downcase == 'width'}.first.name rescue ' '
  end

  def variant_color
    self.option_values.select{|ov| ov.option_type.name.downcase == 'color'}.first.name rescue ' '
  end


end