Admin.controllers :card_properties do

  get :index do
    @card_properties = CardProperty.all
    render 'card_properties/index'
  end

  get :new do
    @card_property = CardProperty.new
    render 'card_properties/new'
  end

  post :create do
    @card_property = CardProperty.new(params[:card_property])
    if @card_property.save
      flash[:notice] = 'CardProperty was successfully created.'
      redirect url(:card_properties, :edit, :id => @card_property.id)
    else
      render 'card_properties/new'
    end
  end

  get :edit, :with => :id do
    @card_property = CardProperty.find(params[:id])
    render 'card_properties/edit'
  end

  put :update, :with => :id do
    @card_property = CardProperty.find(params[:id])
    if @card_property.update_attributes(params[:card_property])
      flash[:notice] = 'CardProperty was successfully updated.'
      redirect url(:card_properties, :edit, :id => @card_property.id)
    else
      render 'card_properties/edit'
    end
  end

  delete :destroy, :with => :id do
    card_property = CardProperty.find(params[:id])
    if card_property.destroy
      flash[:notice] = 'CardProperty was successfully destroyed.'
    else
      flash[:error] = 'Unable to destroy CardProperty!'
    end
    redirect url(:card_properties, :index)
  end
end
