# frozen_string_literal: true

class UsersController < ApplicationController
  def show
    @user = User.find_by(nickname: params[:nickname])
    return if @user

    redirect_to root_path, alert: 'User not found'
  end
end
