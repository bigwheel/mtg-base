Admin.controllers :m12_card_properties do

  get :index do
    @m12_card_properties = M12CardProperty.all
    render 'm12_card_properties/index'
  end

  get :new do
    @m12_card_property = M12CardProperty.new
    render 'm12_card_properties/new'
  end

  post :create do
    @m12_card_property = M12CardProperty.new(params[:m12_card_property])
    if @m12_card_property.save
      flash[:notice] = 'M12CardProperty was successfully created.'
      redirect url(:m12_card_properties, :edit, :id => @m12_card_property.id)
    else
      render 'm12_card_properties/new'
    end
  end

  get :edit, :with => :id do
    @m12_card_property = M12CardProperty.find(params[:id])
    render 'm12_card_properties/edit'
  end

  put :update, :with => :id do
    @m12_card_property = M12CardProperty.find(params[:id])
    if @m12_card_property.update_attributes(params[:m12_card_property])
      flash[:notice] = 'M12CardProperty was successfully updated.'
      redirect url(:m12_card_properties, :edit, :id => @m12_card_property.id)
    else
      render 'm12_card_properties/edit'
    end
  end

  delete :destroy, :with => :id do
    m12_card_property = M12CardProperty.find(params[:id])
    if m12_card_property.destroy
      flash[:notice] = 'M12CardProperty was successfully destroyed.'
    else
      flash[:error] = 'Unable to destroy M12CardProperty!'
    end
    redirect url(:m12_card_properties, :index)
  end
end
