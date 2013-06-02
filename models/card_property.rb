module URI
  class HTTP
    def mongoize
      to_s
    end

    class << self
      def demongoize(url_text)
        URI(url_text)
      end
      def mongoize(object)
        object.mongoize
      end
      def evolve(object)
        object.mongoize
      end
    end
  end
end

module GathererScraper::Attribute
  class AllSets < Array
    def mongoize
      map do |all_set|
        all_set.mongoize
      end
    end

    class << self
      def demongoize(object)
        object.map do |all_set|
          AllSet.demongoize(all_set)
        end
      end
      def mongoize(object)
        object.mongoize
      end
      def evolve(object)
        object.mongoize
      end
    end
  end

  class AllSet
    def mongoize
      { set_name: set_name, rarity: rarity }
    end

    class << self
      def demongoize(object)
        new(object[:set_name], object[:rarity])
      end
      def mongoize(object)
        object.mongoize
      end
      def evolve(object)
        object.mongoize
      end
    end
  end

  class ManaCost
    def mongoize
      mana_symbols
    end

    class << self
      def demongoize(object)
        if object
          new(object)
        else
          object
        end
      end
      def mongoize(object)
        object.mongoize
      end
      def evolve(object)
        object.mongoize
      end
    end
  end

  class CardNumber
    def mongoize
      { number: number, face: face }
    end

    class << self
      def demongoize(object)
        if object
          new(object[:number], object[:face])
        else
          object
        end
      end
      def mongoize(object)
        object.mongoize
      end
      def evolve(object)
        object.mongoize
      end
    end
  end

  class PT
    def mongoize
      { power: power, toughness: toughness }
    end

    class << self
      def demongoize(object)
        if object
          new(object[:power], object[:toughness])
        else
          object
        end
      end
      def mongoize(object)
        object.mongoize
      end
      def evolve(object)
        object.mongoize
      end
    end
  end

  class Type
    def mongoize
      { supertypes: supertypes, cardtypes: cardtypes, subtypes: subtypes }
    end

    class << self
      def demongoize(object)
        new(object[:supertypes], object[:cardtypes], object[:subtypes])
      end
      def mongoize(object)
        object.mongoize
      end
      def evolve(object)
        object.mongoize
      end
    end
  end
end

class CardProperty < GathererScraper::CardProperty
  include Mongoid::Document
  include Mongoid::Timestamps # adds created_at and updated_at fields
  include GathererScraper::Attribute

  # field <name>, :type => <type>, :default => <value>
  field :multiverseid, type: Integer
  field :card_image_url, type: URI::HTTP
  field :card_name, type: String
  field :mana_cost, type: ManaCost
  field :converted_mana_cost, type: Integer
  field :type, type: Type
  field :card_text, type: String
  field :flavor_text, type: String
  field :watermark, type: Symbol
  field :color_indicator, type: Array
  field :p_t, type: PT
  field :loyalty, type: Integer
  field :expansion, type: Symbol
  field :rarity, type: Symbol
  field :all_sets, type: AllSets
  field :card_number, type: CardNumber
  field :artist, type: String

  # You can define indexes on documents using the index macro:
  # index :field <, :unique => true>

  # You can create a composite key in mongoid to replace the default id using the key macro:
  # key :field <, :another_field, :one_more ....>
end
