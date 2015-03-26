Spree::Product.class_eval do

  scope :no_taxons , ->{
    where('id NOT in (?)',Spree::ProductsTaxon.all.map{|pt| pt.product_id}.uniq )
  }


  # if we want to reject type to get in another manner .reject{|t| t.downcase == 'type'}
  #Spree::Property.all.map{|p| p.name.downcase.gsub(' ','_')}.each do |p|
  Spree::Property.all.map{|p| p.name.downcase.gsub(' ','_')}.reject{|t| t.downcase == 'type' || t.downcase == 'color'}.each do |p|
    define_method(%Q{product_#{p}}) do
      self.product_properties.select{|pp| pp.property.name.downcase == p.gsub('_',' ')}.first.value rescue ' '
    end
  end

  def product_type
    type = ' '
    t = self.cat_taxon
    if t
      type = t.permalink.split('/')[1]
    end
    return type
  end

  {ribbon_widths: 'ribbon9width',ribbon_putups: 'ribbon9putup',bow_sizes: 'bow9size',
    widths: 'width',colors: 'color'}.each do |k,val|
    define_method(k) do
      self.variants.collect{|v| eval(%Q{v.variant_#{val}})}.reject{|a| a.nil?||a.blank?}
    end
  end

  def pattern
    if !(self.product_type == 'flowers')
      #self.taxons.first.name rescue ' '
      self.cat_taxon.name rescue ' '
    end
  end

  def cat_taxon
    self.taxons.select{|t| t.permalink.split('/')[0] == 'categories' }.first rescue nil
  end


  def wired_product?
    !(self.description =~ /wired/i || self.name =~ /wired/i).nil?
  end


  searchable do
    text :name, :boost => 2.0
    text :description
    text :pattern do
      pattern
    end
    text :brand do
      product_brand
    end

    text :product_sku, :as => :sku_textp do
      self.variants.map{|s| s.sku}.reject{|e| e.nil?}
    end

    text :product_item_no do
      self.variants.map{|s| s.item_no}.reject{|e| e.nil?}
    end

    text :color do
      colors
    end

    text :widths do
      widths
    end

    string :name, :stored => true

    string :pattern do
      pattern
    end

    string :product_sku, :multiple => true do
      self.variants.map{|s| s.sku}.reject{|e| e.nil?}
    end

    string :product_item_no, :multiple => true do
      self.variants.map{|s| s.item_no}.reject{|e| e.nil?}
    end

    string :color, :multiple => true do
      colors
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


    boolean :wired do
      wired_product?
    end

  end
end
