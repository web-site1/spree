Spree::Product.class_eval do


  Spree::Property.all.map{|p| p.name.downcase.gsub(' ','_')}.each do |p|
    define_method(%Q{product_#{p}}) do
      self.product_properties.select{|pp| pp.property.name.downcase == p.gsub('_',' ')}.first.value rescue ''
    end
  end

  {ribbon_widths: 'ribbon9width',ribbon_putups: 'ribbon9putup',bow_sizes: 'bow9size',
    widths: 'width',colors: 'color'}.each do |k,val|
    define_method(k) do
      self.variants.collect{|v| eval(%Q{v.variant_#{val}})}.reject{|a| a.nil?||a.blank?}
    end
  end


  searchable do
    text :name, :boost => 2.0
    text :description

    string :name, :stored => true


    string :product_sku, :multiple => true do
      self.variants.map{|s| s.sku}.reject{|e| e.nil?}
    end

    string :product_item_no, :multiple => true do
      self.variants.map{|s| s.item_no}.reject{|e| e.nil?}
    end

    string :color do
      product_color
    end

    string :brand do
      product_brand
    end

    string :type do
      product_type
    end

    string :ribbon_widths, :multiple => true do
      ribbon_widths
    end

    string :ribbon_putups, :multiple => true do
      ribbon_putups
    end

    string :bow_sizes, :multiple => true do
      bow_sizes
    end

    string :widths, :multiple => true do
      widths
    end

    string :colors, :multiple => true do
      colors
    end

  end

end
