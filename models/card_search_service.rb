class CardSearchService
  class << self
    def search(query)
      criteria = CardProperty.criteria

      append_condition_equal(query, criteria, :multiverseid)

      append_condition_at_text(query, criteria, :card_name)

      # TODO implement mana_cost query
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

      append_condition_equal(query, criteria, :converted_mana_cost)

      append_condition_all(query, criteria, :'type.supertypes')
      append_condition_all(query, criteria, :'type.cardtypes')
      append_condition_all(query, criteria, :'type.subtypes')

      append_condition_at_text(query, criteria, :card_text)

      append_condition_at_text(query, criteria, :flavor_text)

      append_condition_equal(query, criteria, :watermark)

      append_condition_all(query, criteria, :'color_indicator')

      append_condition_equal(query, criteria, :'p_t.power')
      append_condition_equal(query, criteria, :'p_t.toughness')

      append_condition_equal(query, criteria, :loyalty)

      append_condition_equal(query, criteria, :expansion)

      append_condition_equal(query, criteria, :rarity)

      key_name = :'all_sets'
      if query.has_key?(key_name.to_s) && query[key_name.to_s].is_a?(Hash)
        query[key_name.to_s].values.each do |all_set|
          condition = {}
          condition[:set_name] = all_set[:set_name.to_s].to_sym if all_set.has_key?(:set_name.to_s)
          condition[:rarity] = all_set[:rarity.to_s].to_sym if all_set.has_key?(:rarity.to_s)
          criteria.merge! CardProperty.elem_match(key_name => condition)
        end
      end

      key_name = :'card_number.number'
      if query.has_key?(key_name.to_s)
        criteria.merge! CardProperty.where(key_name => query[key_name.to_s].to_i)
      end
      append_condition_equal(query, criteria, :'card_number.face')

      append_condition_at_text(query, criteria, :artist)

      # TODO: delete after to implement search result paging
      result = if criteria.count == CardProperty.count
                 [].to_json
               else
                 criteria.only(query['result_filter'].values).map { |cp|
                   cp.as_document.delete_if { |k| k == '_id' }
                 }.to_json
               end
    end

    private
    def append_condition(query, criteria, key_name)
      if query.has_key?(key_name.to_s)
        criteria.merge! yield(query[key_name.to_s])
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
      if query.has_key?(key_name.to_s) && query[key_name.to_s].is_a?(Hash)
        criteria.merge! CardProperty.all(key_name => query[key_name.to_s].values.map { |a| a.to_sym } )
      end
    end
  end
end
