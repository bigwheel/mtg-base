class CardSearchService
  class << self
    def append_condition(params, criteria, key_name)
      if params.has_key?(key_name.to_s)
        criteria.merge! yield(params[key_name.to_s])
      end
    end

    def append_condition_at_text(params, criteria, key_name)
      append_condition(params, criteria, key_name) do |param|
        begin
          regexp = Regexp.compile(param, Regexp::IGNORECASE)
        rescue RegexpError
          halt 400
        end
        CardProperty.where(key_name => regexp)
      end
    end

    def append_condition_equal(params, criteria, key_name)
      append_condition(params, criteria, key_name) do |param|
        CardProperty.where(key_name => param)
      end
    end

    def append_condition_all(params, criteria, key_name)
      if params.has_key?(key_name.to_s) && params[key_name.to_s].is_a?(Hash)
        criteria.merge! CardProperty.all(key_name => params[key_name.to_s].values.map { |a| a.to_sym } )
      end
    end

    def search(params)
      criteria = CardProperty.criteria

      params.delete_if { |k, v| v == '' }

      append_condition_equal(params, criteria, :multiverseid)

      append_condition_at_text(params, criteria, :card_name)

      # TODO implement mana_cost query
      #    key_name = :mana_cost
      #    if params.has_key?(key_name.to_s) && params[key_name.to_s].is_a?(Hash)
      #      symbols = params[key_name.to_s].values.map do |sym|
      #        # Refer attribute/mana_cost.rb L101 in GathererScraper gem
      #        p sym
      #        p sym =~ /\{(0|[1-9]\d*)\}/
      #        sym =~ /\{(0|[1-9]\d*)\}/ ? sym.to_i : sym.to_sym
      #      end
      #      p symbols
      #      criteria.merge! CardProperty.all(key_name => symbols)
      #    end

      append_condition_equal(params, criteria, :converted_mana_cost)

      append_condition_all(params, criteria, :'type.supertypes')
      append_condition_all(params, criteria, :'type.cardtypes')
      append_condition_all(params, criteria, :'type.subtypes')

      append_condition_at_text(params, criteria, :card_text)

      append_condition_at_text(params, criteria, :flavor_text)

      append_condition_equal(params, criteria, :watermark)

      append_condition_all(params, criteria, :'color_indicator')

      append_condition_equal(params, criteria, :'p_t.power')
      append_condition_equal(params, criteria, :'p_t.toughness')

      append_condition_equal(params, criteria, :loyalty)

      append_condition_equal(params, criteria, :expansion)

      append_condition_equal(params, criteria, :rarity)

      key_name = :'all_sets'
      if params.has_key?(key_name.to_s) && params[key_name.to_s].is_a?(Hash)
        params[key_name.to_s].values.each do |all_set|
          condition = {}
          condition[:set_name] = all_set[:set_name.to_s].to_sym if all_set.has_key?(:set_name.to_s)
          condition[:rarity] = all_set[:rarity.to_s].to_sym if all_set.has_key?(:rarity.to_s)
          criteria.merge! CardProperty.elem_match(key_name => condition)
        end
      end

      key_name = :'card_number.number'
      if params.has_key?(key_name.to_s)
        criteria.merge! CardProperty.where(key_name => params[key_name.to_s].to_i)
      end
      append_condition_equal(params, criteria, :'card_number.face')

      append_condition_at_text(params, criteria, :artist)

      # TODO: delete after to implement search result paging
      result = if criteria.count == CardProperty.count
                 [].to_json
               else
                 criteria.only(params['result_filter'].values).map { |cp|
                   cp.as_document.delete_if { |k| k == '_id' }
                 }.to_json
               end
    end
  end
end
