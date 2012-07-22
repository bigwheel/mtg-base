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
