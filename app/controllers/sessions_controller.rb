class SessionsController < ApplicationController
  def destroy
    reset_session
    flash[:success] = "Successfully logged out!"
    redirect_to "/"
  end

  def new
    if session["user_id"].blank?
      render "new"
    else
      redirect_to '/users/index'
    end
  end

  def create
    user = User.find_by(username: params["username"])
    if user.present?
      if user.authenticate(params['password'])
        session["user_id"] = user.id
        flash[:success] = "Welcome back, #{user.first_name} #{user.last_name}"
        redirect_to "/users/index"
      else
        flash[:danger] = "Wrong information! Check the username or password you entered!"
        redirect_to "/login"
      end
    else
      flash[:danger] = "Wrong information! Check the username or password you entered!"
      redirect_to "/login"
    end
  end

end
