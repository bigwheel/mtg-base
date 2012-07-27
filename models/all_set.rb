class AllSet
  include Mongoid::Document
  field :set_name, type: Symbol
  validates_presence_of :set_name
  field :rarity,   type: Symbol
  validates_presence_of :rarity
  validates_inclusion_of :rarity, in: ALL_RARITY_LIST = [:'Mythic Rare', :Rare, :Uncommon, :Common, :Land, :Special]
  embedded_in :m12_card_property
  def self.news_alternative(node)
    return [] if node == nil
    alt_texts = node.xpath('div/a/img/@alt')
    alt_texts.map do |alt|
      _, set_name, rarity = alt.content.strip.match(/\A(.*) \((.*)\)\Z/).to_a
      self.new(set_name: set_name.to_sym, rarity: rarity.to_sym)
    end
  end
end
