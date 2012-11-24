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
    CardProperty.fields.keys.map { |keyname|
      self.get_length(params[keyname])
    }.max
  end

  get :search do
    params.delete_if { |k, v| v == '' }

    result = CardSearchService.search(params)
    content_type 'application/json'
    halt 200, { 'Access-Control-Allow-Origin' => '*' }, result
  end
end
