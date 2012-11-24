MtgPackGenerator.controller do
  get :index do
    render 'index'
  end

  get :decklist do
    render 'decklist'
  end

  post :jsonize do
    result = params['cards_of_deck'].split(/\r\n/).map { |line|
      if /\A(?<number_of_cards>\d*?) (?<card_name>.*)\Z/ =~ line
        result_card = CardProperty.where(card_name: card_name).last
        if result_card
          {
            number_of_cards: number_of_cards,
            card_property: result_card.as_document
          }
        else
          nil
        end
      else
        nil
      end
    }.keep_if { |v| v }.to_json
    content_type 'application/json'
    halt 200, { 'Access-Control-Allow-Origin' => '*' }, result
  end

  post :get_card_details do
    def self.get_length obj
      if obj.is_a? Array
        obj.size
      else
        0
      end
    end
    number_of_card = CardProperty.fields.keys.map { |keyname|
      self.get_length(params[keyname])
    }.max

    content_type 'application/json'
    (0...number_of_card).map { |index|
      query = {}
      CardProperty.fields.keys.each do |keyname|
        if params[keyname].is_a? Array
          query[keyname] = params[keyname][index]
        end
      end
      CardSearchService.search(query).last.as_document
    }.to_json
  end

  get :search do
    criteria = CardSearchService.search(params)

    # TODO: delete after to implement search result paging
    result = if criteria.count == CardProperty.count
               [].to_json
             else
               criteria.only(params['result_filter'].values).map { |cp|
                 cp.as_document.delete_if { |k| k == '_id' }
               }.to_json
             end

    content_type 'application/json'
    halt 200, { 'Access-Control-Allow-Origin' => '*' }, result
  end
end
