class String

  NOBREAKSPACE = "\xC2\xA0"

  COLOR_ABBREVS = {
    'antique' => 'ANTQ',
    'black' => 'BLK',
    'blue' => 'BLU',
    'brown' => 'BRN',
    'burgundy' => 'BURG',
    'cashmere' => 'CSHMR',
    'chocolate' => 'CHOC',
    'colonial' => 'CLNL',
    'dark' => 'DK',
    'eggplant' => 'EGPLT',
    'electric' => 'ELEC',
    'fuchsia' => 'FCHA',
    'green' => 'GRN',
    'gray' => 'GRA',
    'inspiration' => 'INSP',
    'light' => 'LT',
    'passion' => 'PSSN',
    'pink' => 'PK',
    'purple' => 'PRPL',
    'shocking' => 'SHK',
    'red' => 'RED',
    'orange' => 'ORN',
    'orchid' => 'ORCH',
    'porcelain' => 'PRCLN',
    'lavender' => 'LAV',
    'lime' => 'LIM',
    'mauve' => 'MVE',
    'juice' => 'JCE',
    'jungle' => 'JGL',
    'rainbow' => 'RNBW',
    'sherbert' => 'SHRBRT',
    'silver' => 'SILV',
    'spring' => 'SPG',
    'turquoise' => 'TURQ',
    'violet' => 'VIO',
    'white' => 'WHT',
    'wild' => 'WLD',
    'williamsberg' => 'WLSMBRG',
    'willow' => 'WLW',
    'yellow' => 'YEL',
    'babymaize' => 'BBYMAIZ',
    'baby' => 'BBY',
    'maize' => 'MAIZ',
    'williamsburg' => 'WILMSBRG',
    'soft' => 'SFT'
  }



  def abbrev_colors
    s = self
    COLOR_ABBREVS.each_key do |ca|
      s = s.gsub(/#{ca}/i, COLOR_ABBREVS[ca])
    end
    s
  end

  # Remove double quote from begin, end and change pair of double quotes to one
  def remove_quotes
    desc = self.gsub(/^"/,'')
    desc = desc.gsub(/"$/,'')
    desc = desc.gsub('""', '"')
  end

  def abbrev_pattern(max_len)
    return self if self.blank?
    s = self
    s = s.gsub('Wired Edge','WE')
    s = s.gsub('&trade;','')
    s = s.gsub("'",'')
    s = s.gsub(/bag$/i,'') if s.length > max_len
    s = s.gsub('Double Face Satin', 'DFS') if s.length > max_len
    s = s.gsub('Feather Edge', 'FE') if s.length > max_len
    s.strip
  end

  def abbrev_size
    s = self
    s = s.gsub(/ Inch/i,'"')
    s = s.gsub(/ Inc$/i,'"')
    s = s.gsub(' x ','x')
  end
  def remove_no_break_space
    self.gsub(NOBREAKSPACE,'')
  end

  def to_numeric
    self.gsub(/[^\d\.]/,'')
  end

  def number?
    true if Float(self) rescue false
  end

  def map_human_to_number
    s = self
    s = s.gsub('one hundred and nine', '109')
    s = s.gsub('one hundred', '100')
    s = s.gsub('four hundred', '400')
    s = s.gsub('five hundred', '500')
    s = s.gsub('twenty-five', '25')
    s = s.gsub('twenty five', '25')
    s = s.gsub('ten', '10')
    s = s.gsub('eleven', '11')
    s = s.gsub('fifteen', '15')
    s = s.gsub('twenty', '20')
    s = s.gsub('thirty', '30')
    s = s.gsub('forty', '40')
    s = s.gsub('fifty', '50')
  end

  def no_numbers?
    self.gsub(/[^\d]/,'').empty?
  end

  def to_dec
    begin
      s = self.gsub(/[^0-9\-\/]/,'')
      eval('1.0 * ' + s.gsub(/-/,' + 1.0 * ')).to_f
    rescue Exception => e
        return 0.00
    end
  end

end