require 'net/http'
require 'open-uri'
require 'uri'

class M12CardProperty
  include Mongoid::Document
  include Mongoid::Timestamps # adds created_at and updated_at fields

  STRIPED_TEXT = '\A(\S|\S.*\S)\Z'
  STRIPED_TEXT_REGEXP  = Regexp.new(STRIPED_TEXT)
  STRIPED_TEXTS_REGEXP = Regexp.new(STRIPED_TEXT, Regexp::MULTILINE)

  ALL_RARITY_LIST = [:'Mythic Rare', :Rare, :Uncommon, :Common, :'Basic Land']

  # field <name>, :type => <type>, :default => <value>
  field :card_name,           :type => String
  validates_presence_of :card_name
  validates_format_of :card_name, :with => STRIPED_TEXT_REGEXP

  embeds_one :mana_cost
  validates_associated :mana_cost

  field :converted_mana_cost, :type => Integer
  validates_numericality_of :converted_mana_cost, only_integer: true, greater_than_or_equal_to: 0, allow_nil: true

  embeds_one :type
  validates_presence_of :type
  validates_associated :type

  field :card_text,           :type => String
  validates_format_of :card_text, with: STRIPED_TEXTS_REGEXP, allow_nil: true

  field :flavor_text,         :type => String
  validates_format_of :flavor_text, with: STRIPED_TEXTS_REGEXP, allow_nil: true

  embeds_one :p_t
  validates_associated :p_t

  field :expansion,           :type => String
  validates_presence_of :expansion
  validates_format_of :expansion, :with => STRIPED_TEXT_REGEXP

  field :rarity,              :type => Symbol
  validates_presence_of :rarity
  validates_inclusion_of :rarity, in: ALL_RARITY_LIST

  embeds_many :all_sets
  validates_exclusion_of :all_sets, in: [nil]
  validates_associated :all_sets

  field :card_number,         :type => Integer
  validates_presence_of :card_number
  validates_numericality_of :card_number, only_integer: true, greater_than_or_equal_to: 1

  field :artist,              :type => String
  validates_presence_of :artist
  validates_format_of :artist, :with => STRIPED_TEXT_REGEXP

  # You can define indexes on documents using the index macro:
  # index :field <, :unique => true>

  # You can create a composite key in mongoid to replace the default id using the key macro:
  # key :field <, :another_field, :one_more ....>

  def self.create_from_id multiverseid
    url = CardUrl.new(multiverseid: multiverseid)
    doc = Nokogiri::HTML(open(url.concat))

    card_property = parse_doc(doc)
    card_property.save!
    card_property
  end

  private
  def self.parse_doc(doc)
    card_name = value_of_label(doc, 'Card Name')
    converted_mana_cost = value_of_label(doc, 'Converted Mana Cost')
    card_text = value_of_label(doc, 'Card Text') do |node|
      node.inner_html.strip
    end
    flavor_text = value_of_label(doc, 'Flavor Text') do |node|
      node.inner_html.strip
    end
    expansion = value_of_label(doc, 'Expansion') do |node|
      node.at_xpath("div/a[contains(@href, 'Pages/Search')]").content.strip
    end
    rarity = value_of_label(doc, 'Rarity') do |node|
      node.at_xpath('span').content.strip.to_sym
    end
    card_number = value_of_label(doc, 'Card #')
    artist = value_of_label(doc, 'Artist') do |node|
      node.at_xpath('a').content.strip
    end

    property = { card_name: card_name,
                 converted_mana_cost: converted_mana_cost,
                 card_text: card_text, flavor_text: flavor_text,
                 expansion: expansion, rarity: rarity,
                 card_number: card_number, artist: artist }
    card_property = new(property.select { |e| e != nil })
    card_property.mana_cost = ManaCost.new_alternative(node_by_label(doc, 'Mana Cost'))
    card_property.p_t = PT.new_alternative(node_by_label(doc, 'P/T'))
    card_property.type = Type.new_alternative(node_by_label(doc, 'Types'))
    card_property.all_sets.concat(AllSet.news_alternative(node_by_label(doc, 'All Sets')))
    card_property
  end 
  def self.node_by_label(nokogiri_doc, label_name)
    nokogiri_doc.at_xpath("//div[@class='label'][contains(text(), '#{label_name}')]/../div[@class='value']")
  end
  def self.value_of_label(nokogiri_doc, label_name)
    node = node_by_label(nokogiri_doc, label_name)
    if node == nil
      nil
    elsif block_given?
      yield node
    else
      node.content.strip
    end
  end
end
