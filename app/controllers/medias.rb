Pandrino.controllers :medias do

  get :index do
    @medias = Media.all
    render 'medias/index'
  end

  post :create, :map => "/medias" do
    @media = Media.new(params[:media])
    @media.save
    render 'medias/show'
  end

  get :show, :map => "/medias/:id" do
    @media = Media.find(params[:id])
    render 'medias/show'
  end

  put :update, :map => "/medias/:id" do
    @media = Media.find(params[:id])
    @media.update_attributes(params[:media])
    render 'medias/show'
  end

  post :encode, :map => "/medias/:id/encode" do
    @media = Media.find(params[:id])
    if params[:command] == 'demux'
      @media.demux(:audio)
      @media.demux(:video)
    end
    @media.reload
    render 'medias/encoding_medias'
  end

end
