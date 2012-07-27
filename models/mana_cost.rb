class ManaCost
  include Mongoid::Document
  embedded_in :m12_card_property
  MANA_SYMBOL_LIST = [:White, :Blue, :Black, :Red, :Green, :'Variable Colorless']
  field :mana_symbols, type: Array
  validates_presence_of :mana_symbols
  validate do
    mana_symbols.each do |mana_symbol|
      if mana_symbol.kind_of? Integer
        p mana_symbol && errors.add(:mana_symbols, "#{mana_symbol} is not a Natural Number") unless 0 <= mana_symbol
      elsif mana_symbol.kind_of? Symbol
        p mana_symbol && errors.add(:mana_symbols, "#{mana_symbol} is not contained in Mana Symbol List") unless MANA_SYMBOL_LIST.include? mana_symbol
      else
        p mana_symbol && errors.add(:mana_symbols, "#{mana_symbol} is neither a kind of Integer nor Symbol")
      end
    end
  end
  def self.new_alternative(node)
    return nil if node == nil
    mana_symbols = node.xpath('img/@alt').map do |alt|
      alt.content.strip
    end

    sym_and_int = mana_symbols.map do |symbol|
      if symbol =~ /\A\d*\Z/
        symbol.to_i
      else
        symbol.to_sym
      end
    end
    ManaCost.new(mana_symbols: sym_and_int)
  end
end
