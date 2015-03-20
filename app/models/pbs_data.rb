# Parent class for any PBS table

class PbsData < ActiveRecord::Base
                          0
  self.abstract_class = true

  cattr_reader :db
  @@db = APP_CONFIG[:pbs_db]
  # establish_connection  "#{Rails.env}_sql".to_sym
  # puts "Here in PbsData"

  # Pass a single records's attributes and I'll do the rest
  def self.import_record(attrs)
    result = nil
    new_record = new()
    new_record.assign_attributes(attrs)
    begin
      new_record.save
    rescue Exception => e
      result = "#{self.class.to_s}: Error occurred adding record: #{e.to_s}"
    end
    result
  end

  def self.item_no_as_stored(str)
    str = str.number? ? str.rjust(15, '0') : str
  end

  def fill_from_template
    return unless new_record?
    default_values =  YAML.load(ERB.new(File.read("#{::Rails.root.to_s}/config/pbs_defaults.yml")).result)
    self.assign_attributes(default_values[self.class.to_s])
  end

  def handle_numerics
    self.item_no = Itmfil.item_no_as_stored(item_no) rescue nil
  end


  def handle_dup_fields
    # set all item_no_n fields = item_no
    attributes.keys.select{|k| k.match(/item_no_\d+/)}.each {|f| self[f] = item_no}
  end

end