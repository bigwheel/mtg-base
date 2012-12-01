class CardSearchService
  QUERY_KEYNAME = {
    :multiverseid => :multiverseid,
    :card_name => :card_name,
    # mana_cost: mana_cost, # don't forget when enable mana_cost query
    :converted_mana_cost => :converted_mana_cost,
    :'type.supertypes' => :'type.supertypes',
    :'type.cardtypes' => :'type.cardtypes',
    :'type.subtypes' => :'type.subtypes',
    :card_text => :card_text,
    :flavor_text => :flavor_text,
    :watermark => :watermark,
    :'color_indicator' => :'color_indicator',
    :'p_t.power' => :'p_t.power',
    :'p_t.toughness' => :'p_t.toughness',
    :loyalty => :loyalty,
    :expansion => :expansion,
    :rarity => :rarity,
    :'all_sets' => :'all_sets',
    :'card_number.number' => :'card_number.number',
    :'card_number.face' => :'card_number.face',
    :artist => :artist,

    # elements only query parameters
    :result_filter => :result_filter,
  }

  class << self
    def search(query, strict = false)
      # TODO: rewrite as non side-effect
      query.delete_if { |k, v| v == '' }

      criteria = CardProperty.criteria

      append_condition_for_text = method(strict ? :append_condition_equal : :append_condition_at_text)

      append_condition_equal(query, criteria, :multiverseid)
      append_condition_for_text.call(query, criteria, :card_name)
      append_condition_for_mana_cost(query, criteria)
      append_condition_equal(query, criteria, :converted_mana_cost)
      append_condition_all(query, criteria, :'type.supertypes')
      append_condition_all(query, criteria, :'type.cardtypes')
      append_condition_all(query, criteria, :'type.subtypes')
      append_condition_for_text.call(query, criteria, :card_text)
      append_condition_for_text.call(query, criteria, :flavor_text)
      append_condition_equal(query, criteria, :watermark)
      append_condition_all(query, criteria, :'color_indicator')
      append_condition_equal(query, criteria, :'p_t.power')
      append_condition_equal(query, criteria, :'p_t.toughness')
      append_condition_equal(query, criteria, :loyalty)
      append_condition_equal(query, criteria, :expansion)
      append_condition_equal(query, criteria, :rarity)
      append_condition_for_all_sets(query, criteria)
      append_condition_for_card_number_number(query, criteria)
      append_condition_equal(query, criteria, :'card_number.face')
      append_condition_for_text.call(query, criteria, :artist)

      criteria
    end

    # remember that search-function result is criteria
    # however this function returns Array of Hash
    def search_with_filtering(query, strict = false)
      criteria = search(query, strict)
      append_condition(query, criteria, :result_filter) do |result_filter|
        CardProperty.only(result_filter.values)
      end
      criteria.map { |cp|
        cp.as_document.delete_if { |k| k == '_id' }
      }
    end

    private
    def append_condition(query, criteria, key_name)
      key_name_str = QUERY_KEYNAME[key_name].to_s
      if query.has_key?(key_name_str)
        criteria.merge! yield(query[key_name_str])
      end
    end

    def append_condition_at_text(query, criteria, key_name)
      append_condition(query, criteria, key_name) do |param|
        begin
          regexp = Regexp.compile(param, Regexp::IGNORECASE)
        rescue RegexpError
          halt 400
        end
        CardProperty.where(key_name => regexp)
      end
    end

    def append_condition_equal(query, criteria, key_name)
      append_condition(query, criteria, key_name) do |param|
        CardProperty.where(key_name => param)
      end
    end

    def append_condition_all(query, criteria, key_name)
      key_name_str = QUERY_KEYNAME[key_name].to_s
      if query.has_key?(key_name_str) && query[key_name_str].is_a?(Hash)
        criteria.merge! CardProperty.all(QUERY_KEYNAME[key_name] => query[key_name_str].values.map { |a| a.to_sym } )
      end
    end

    def append_condition_for_all_sets(query, criteria)
      key_name = :'all_sets'
      if query.has_key?(key_name.to_s) && query[key_name.to_s].is_a?(Hash)
        query[key_name.to_s].values.each do |all_set|
          condition = {}
          condition[:set_name] = all_set[:set_name.to_s].to_sym if all_set.has_key?(:set_name.to_s)
          condition[:rarity] = all_set[:rarity.to_s].to_sym if all_set.has_key?(:rarity.to_s)
          criteria.merge! CardProperty.elem_match(key_name => condition)
        end
      end
    end

    def append_condition_for_card_number_number(query, criteria)
      key_name = :'card_number.number'
      if query.has_key?(key_name.to_s)
        criteria.merge! CardProperty.where(key_name => query[key_name.to_s].to_i)
      end
    end

    def append_condition_for_mana_cost(query, criteria)
      # TODO: implement mana_cost query
      #    key_name = :mana_cost
      #    if query.has_key?(key_name.to_s) && query[key_name.to_s].is_a?(Hash)
      #      symbols = query[key_name.to_s].values.map do |sym|
      #        # Refer attribute/mana_cost.rb L101 in GathererScraper gem
      #        p sym
      #        p sym =~ /\{(0|[1-9]\d*)\}/
      #        sym =~ /\{(0|[1-9]\d*)\}/ ? sym.to_i : sym.to_sym
      #      end
      #      p symbols
      #      criteria.merge! CardProperty.all(key_name => symbols)
      #    end
    end
  end
end
