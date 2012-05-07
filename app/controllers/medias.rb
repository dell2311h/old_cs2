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
    encoder = Encoder.new(params[:encoder])
    if encoder.save
      Resque.enqueue(Conveyor, encoder.id)
      res = {:status => 'processing', :message => 'Your request was added to processing.'}
    else
      res = {:status => 'failure', :message => "Wrong request! #{encoder.errors.full_messages.join(". ")}"}
    end
    render res
  end

end
