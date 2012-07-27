class PT
  include Mongoid::Document
  PT_REGEXP = /\d+|\*/
  field :power,     type: String
  validates_presence_of :power
  validates_format_of :power, with: PT_REGEXP
  field :toughness, type: String
  validates_presence_of :toughness
  validates_format_of :toughness, with: PT_REGEXP
  embedded_in :m12_card_property
  def self.new_alternative(node)
    if node == nil
      nil
    else
      pt = self.new
      match_data = node.content.strip.match /^(#{PT_REGEXP.to_s}) \/ (#{PT_REGEXP.to_s})$/
      pt.power = match_data[1]
      pt.toughness = match_data[2]
      pt
    end
  end
end
