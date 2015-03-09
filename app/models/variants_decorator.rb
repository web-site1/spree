Spree::Variant.class_eval do
  Spree::OptionType.all.map{|p| p.name.downcase.gsub(' ','_').gsub('-','9')}.each do |p|

    define_method(%Q{variant_#{p}}) do
      self.option_values.select{|ov| ov.option_type.name.downcase == p.gsub('_',' ').gsub('9','-')}.first.name rescue ''
    end

  end


end