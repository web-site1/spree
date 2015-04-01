module Spree
  Variant.class_eval do

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

    def has_color?
      !(self.option_values.select{|ov| ov.option_type.name.downcase == 'color'}.empty?)
    end

    def cat_and_subcat
      rcat = []
      taxon  = self.product.cat_taxon rescue nil
      if taxon
        split_perm = taxon.permalink.split('/')
        l = split_perm.length
        rcat << split_perm[l-2].gsub('-',' ').titlecase rescue ' '
        rcat << split_perm[l-1].gsub('-',' ').titlecase rescue ' '
      end
      return rcat
    end


    alias_method :orig_price_in, :price_in
    def price_in(currency)
      p = item_no.nil? ? nil : itmfil.get_price
      return orig_price_in(currency) unless p
      Spree::Price.new(:variant_id => self.id, :amount => p, :currency => currency)
    end

    def price
      price_in('USD').amount
    end

    def display_price
      p = item_no.nil? ? nil : itmfil.get_price
      return Spree::Money.new(999999.99, :currency => currency).to_s unless p
      Spree::Money.new(p, :currency => currency).to_s
    end

  end

end