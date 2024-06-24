# frozen_string_literal: true

class UsersController < ApplicationController
  def show
    @user = User.find_by!(nickname: params[:nickname])
  end

  def index
    sanitized_params = params[:search].to_s.gsub('@', '').strip
    @users = User.search_by_param(sanitized_params).order(:first_name, :last_name, :nickname).page(params[:page])
  end
end
