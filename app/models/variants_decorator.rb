Spree::Variant.class_eval do
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