# frozen_string_literal: true

class LikesController < ApplicationController
  def create
    @likable = params[:likable_type].constantize.find(params[:likable_id])
    current_user.like(@likable)
    respond_to(&:js)
  end

  def destroy
    @likable = current_user.likes.find(params[:id]).likable
    current_user.unlike(@likable)
    respond_to(&:js)
  end
end
