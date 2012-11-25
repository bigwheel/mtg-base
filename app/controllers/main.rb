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
    content_type 'application/json'
    params[:'card_list'.to_s].map { |unused, card_query|
      CardSearchService.search_with_filtering(card_query).last
    }.to_json
  end

  get :search do
    result = CardSearchService.search_with_filtering(params)

    # TODO: delete after to implement search result paging
    result = [] if result.count == CardProperty.count

    content_type 'application/json'
    halt 200, { 'Access-Control-Allow-Origin' => '*' }, result.to_json
  end
end
