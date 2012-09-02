MtgPackGenerator.controller do
  get :index do
    render 'index'
  end

  get :card_property do
    CardProperty.where(expansion: params[:card_set]).map do |card_property|
      { rarity: card_property.rarity,
        card_image_url: card_property.card_image_url.to_s,
        multiverseid: card_property.multiverseid }
    end.to_json
  end
end
