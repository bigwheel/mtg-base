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

class GathererUrl < UrlWithParams
  def initialize(params = {})
    gatherer_url = 'http://gatherer.wizards.com/Pages/Search/Default.aspx'
    super(gatherer_url, params_filter(params))
  end

  def append_params new_params
    super(params_filter(new_params))
  end

  def params_filter(params)
    params[:set] = '["' + params[:set] + '"]' if params.has_key?(:set)
    params
  end
  private :params_filter
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
end
