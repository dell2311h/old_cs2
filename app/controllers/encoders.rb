Pandrino.controllers :encoders do

  get :index do
    @encoders = Encoder.all
    render 'encoders/index'
  end

  post :create, :map => "/encoders" do
    @encoder = Encoder.new(params[:encoder])
    if @encoder.save
      Resque.enqueue(Conveyor, @encoder.id)
      res = {:status => 'processing', :message => 'Your request was added to processing.'}
    else
      res = {:status => 'failure', :message => "Wrong request! #{@encoder.errors.full_messages.join(". ")}"}
    end
    render res
  end

end
