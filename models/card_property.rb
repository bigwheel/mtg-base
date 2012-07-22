require 'net/http'
require 'open-uri'
require 'nokogiri'
require 'uri'

class UrlWithParams
  def initialize(path, params = {})
    @path = path
    @params = params
  end

  def concat
    params_str_pair = @params.collect do |k,v|
      "#{k}=#{v}"
    end
    URI.parse(URI.encode(@path + '?' + params_str_pair.join('&')))
  end

  def append_params new_params
    UrlWithParams.new(@path, @params.merge(new_params))
  end

  def remove_params key
    new_params = @params.dup
    new_params.delete(key)
    UrlWithParams.new(@path, new_params)
  end
end

class CardUrl < UrlWithParams
  def initialize(params = {})
    card_url = 'http://gatherer.wizards.com/Pages/Card/Details.aspx'
    super(card_url, params)
  end
end

class SearchUrl < UrlWithParams
  def initialize(params = {})
    search_url = 'http://gatherer.wizards.com/Pages/Search/Default.aspx'
    super(search_url, params_filter(params))
  end

  def append_params new_params
    super(params_filter(new_params))
  end

  private
  def params_filter(params)
    if params.has_key?(:set)
      params = params.dup
      params[:set] = '["' + params[:set] + '"]'
    end
    params
  end
end

class CardProperty
  include Mongoid::Document
  include Mongoid::Timestamps # adds created_at and updated_at fields

  # field <name>, :type => <type>, :default => <value>
  field :card_name,           :type => String
  field :mana_cost,           :type => Array
  field :converted_mana_cost, :type => Integer
  field :types,               :type => String
  field :card_text,           :type => String
  field :p_t,                 :type => String
  field :expansion,           :type => String
  field :rarity,              :type => String
  field :all_sets,            :type => Array
  field :card_number,         :type => Integer
  field :artist,              :type => String

  # You can define indexes on documents using the index macro:
  # index :field <, :unique => true>

  # You can create a composite key in mongoid to replace the default id using the key macro:
  # key :field <, :another_field, :one_more ....>

  def CardProperty.create_from_id multiverseid
    url = CardUrl.new(multiverseid: multiverseid)
    doc = Nokogiri::HTML(open(url.concat))

    card_name = value_of_label(doc, 'Card Name')
    mana_cost = value_of_label(doc, 'Mana Cost') do |node|
      node.xpath('img/@alt').map do |alt|
        alt.content.strip
      end
    end
    converted_mana_cost = value_of_label(doc, 'Converted Mana Cost')
    types = value_of_label(doc, 'Types')
    card_text = value_of_label(doc, 'Card Text') do |node|
      node.inner_html.strip
    end
    flavor_text = value_of_label(doc, 'Flavor Text') do |node|
      node.inner_html.strip
    end
    p_t = value_of_label(doc, 'P/T')
    expansion = value_of_label(doc, 'Expansion') do |node|
      node.at_xpath("div/a[contains(@href, 'Pages/Search')]").content.strip
    end
    rarity = value_of_label(doc, 'Rarity') do |node|
      node.at_xpath('span').content.strip
    end
    all_sets = value_of_label(doc, 'All Sets', []) do |node|
      node.xpath('div/a/img/@alt').map do |alt|
        alt.content.strip
      end
    end
    card_number = value_of_label(doc, 'Card #')
    artist = value_of_label(doc, 'Artist') do |node|
      node.at_xpath('a').content.strip
    end
    create!(card_name: card_name, mana_cost: mana_cost,
            converted_mana_cost: converted_mana_cost, types: types,
            card_text: card_text, flavor_text: flavor_text, p_t: p_t,
            expansion: expansion, rarity: rarity, all_sets: all_sets,
            card_number: card_number, artist: artist)
  end

  private
  def CardProperty.value_of_label(nokogiri_doc, label_name, value_when_not_found = '')
    label_node = nokogiri_doc.at_xpath("//div[@class='label'][contains(text(), '#{label_name}')]")
    if label_node == nil
      value_when_not_found
    else
      node = label_node.parent.at_xpath("div[@class='value']")
      if block_given?
        yield node
      else
        node.content.strip
      end
    end
  end
end
