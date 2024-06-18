# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :set_commentable

  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user
    if @comment.save
      respond_to(&:js)
    else
      post_redirect_path(@commentable)
    end
  end

  private

  def set_commentable
    @commentable = comment_params[:commentable_type].constantize.find(comment_params[:commentable_id])
  end

  def comment_params
    params.require(:comment).permit(:content, :commentable_type, :commentable_id)
  end

  def post_redirect_path(commentable)
    if commentable.is_a?(Post)
      post_path(commentable)
    else
      post_redirect_path(commentable.commentable)
    end
  end
end
