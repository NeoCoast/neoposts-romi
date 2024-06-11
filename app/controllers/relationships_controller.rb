# frozen_string_literal: true

class RelationshipsController < ApplicationController
  def create
    @user = User.find(params[:followed_id])
    current_user.follow(@user)
    respond_with_format(@user)
  end

  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow(@user)
    respond_with_format(@user)
  end

  def respond_with_format(user)
    respond_to do |format|
      format.html { redirect_to show_user_path(user.nickname) }
      format.js
    end
  end
end
