Pandrino.controllers :profiles do

  get :index do
    @profiles = Profile.all
    render 'profiles/index'
  end

end
