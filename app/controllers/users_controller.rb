# frozen_string_literal: true

class UsersController < ApplicationController
  def show
    @user = User.find_by!(nickname: params[:nickname])
  end

  def index
    @users = User.order(:first_name, :last_name, :nickname).page params[:page]
  end
end
