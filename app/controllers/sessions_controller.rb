class SessionsController < ApplicationController
 
  #LOGIN HERE
  def new
   #if already logged in?
    @user = current_user
    redirect_to user_url(@user) if logged_in?
  end
  
  def create
    @user = User.find_by_credentials(session_params[:email],
                                     session_params[:password])
    unless @user.nil?
       login!(@user)
       redirect_to user_url(@user) 
    else
      flash[:errors]  = ["Invalid Credentials"]
      render :new
    end
  end

  def destroy
  end

  private
  def session_params
    params.require(:user).permit(:email,:password,:id)
  end

end
