# -*- encoding: utf-8 -*-

class Type
  include Mongoid::Document
  # imcomplete lists
  ALL_CARDTYPE_LIST = [:Land, :Creature, :Enchantment, :Artifact, :Instant,
                      :Tribal, :Sorcery, :Planeswalker]
  ALL_SUPERTYPE_LIST = [:Basic, :Legendary, :World, :Snow]
  field :supertypes, type: Array
  field :cardtypes,  type: Array
  validates_presence_of :cardtypes
  field :subtypes,   type: Array
  embedded_in :m12_card_property
  validate do
    errors.add(:supertypes, 'nil') if supertypes == nil
    errors.add(:subtypes, 'nil') if subtypes == nil
    supertypes.each do |supertype|
      unless ALL_SUPERTYPE_LIST.include? supertype
        errors.add(:supertypes, "#{supertype} is not a supertype.")
      end
    end
    cardtypes.each do |cardtype|
      unless ALL_CARDTYPE_LIST.include? cardtype
        errors.add(:cardtypes, "#{cardtype} is not a cardtype.")
      end
    end
  end
  def self.new_alternative(node)
    if node == nil
      nil
    else
      type = self.new
      _, supertype_and_cardtypes, subtypes =
        node.content.strip.match(/\A(.*?)(?:  — (.*))?\Z/).to_a
      s_c_types_symbol = supertype_and_cardtypes.split(' ').map {|t| t.to_sym}
      type.supertypes, type.cardtypes =
        s_c_types_symbol.partition{|symbol| ALL_SUPERTYPE_LIST.include? symbol}

      type.subtypes = if subtypes == nil
                        []
                      else
                        subtypes.split(' ').map {|t| t.to_sym}
                      end
      type
    end
  end
end
