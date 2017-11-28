require 'digest/sha1'

class UsersController < ApplicationController
  def new
    if session["user_id"].blank?
      render "new"
    else
      redirect_to '/users/index'
    end
  end

  def create
    @user = User.new
    @user.first_name = params["first_name"]
    @user.last_name = params["last_name"]
    @user.username = params["username"]
    @user.password = params["password"]
    @user.api_key = Digest::SHA1.hexdigest(@user.username)
    if @user.save
      flash[:success] = "Thanks for signing up"
      session["user_id"] = @user.id
      redirect_to "/users/index"
    else
      flash[:danger] = @user.errors.full_messages.first
      redirect_to "/users/new"
    end
  end

  def index
    if session["user_id"].blank?
      flash[:success] = "Please log in first."
      redirect_to "/login"
    else
      @user = User.find_by(id: session["user_id"])
      render "index"
    end
  end

  def destroy
    @user = User.find_by(id: session["user_id"])
    @user.destroy
    reset_session
    flash[:success] = "Successfully destroyed your account!"
    redirect_to "/"
  end
end
