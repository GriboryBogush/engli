# frozen_string_literal: true

# Just displays all users on #index and user's phrases on #show
class UsersController < ApplicationController
  def index
    @users = User.order(carma: :desc).paginate(page: params[:page])
  end

  def show
    @user = User.friendly.find(params[:id])
    @phrases = @user.phrases.paginate(page: params[:page])
  end
end
