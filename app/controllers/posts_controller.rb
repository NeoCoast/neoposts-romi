# frozen_string_literal: true

class PostsController < ApplicationController
  def show
    @post = Post.find(params[:id])
  end

  def index
    @posts = current_user.following_posts.newest_first
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.new(post_params)

    if @post.save
      redirect_to @post
    else
      render :new
    end
  end

  def destroy
    @post = current_user.posts.find(params[:id])
    @post.destroy
    redirect_to root_path
  end

  private

  def post_params
    params.require(:post).permit(:title, :body, :image)
  end
end
