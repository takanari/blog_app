class LoginsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.registered?
      session[:login] = @user.id
      redirect_to user_posts_path(@user)
    else
      render :new
    end
  end

  def destroy
    session[:login] = nil
    redirect_to new_login_path
  end

  private

    def user_params
      params.require(:user).permit(:email, :password)
    end
end
