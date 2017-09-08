class BandsController < ApplicationController


  def index
    @bands = Band.all
  end

  def new
    render :new
  end

  def create
    render :create
  end

  def destroy
    render :destroy
  end

  def edit
    render :edit
  end

  def update
    render :update
  end

  def show
    @band = Band.find(params[:id])
    render :show
  end

  private 
  def band_params
    params.require(:band).permit(:name,:id)
  end

end
