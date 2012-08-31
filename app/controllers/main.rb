MtgPackGenerator.controller do
  get :index do
    render 'index'
  end
  get :cardproperty do
    CardProperty.all.to_json
    #M12CardProperty.only(:multiverseid).map {|cp| cp.multiverseid}.to_json
  end
  get :cardproperty, with: :multiverseid do
    CardProperty.where(multiverseid: params[:multiverseid]).first.to_json
  end
end
