MtgPackGenerator.controller do
  get :index do
    render 'index'
  end
  get :cardproperty do
    CardProperty.where(expansion: 'Magic 2013').map do |card_property|
      { rarity: card_property.rarity,
        multiverseid: card_property.multiverseid }
    end.to_json
    #M12CardProperty.only(:multiverseid).map {|cp| cp.multiverseid}.to_json
  end
  get :cardproperty, with: :multiverseid do
    CardProperty.where(multiverseid: params[:multiverseid]).first.to_json
  end
end
