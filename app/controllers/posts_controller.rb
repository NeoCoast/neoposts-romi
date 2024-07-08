# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :set_sort_and_filters, only: :index

  def show
    @post = Post.find(params[:id])
  end

  def index
    @posts = current_user.following_posts.filter_by(@filters[0], @filters[1], @filters[2]).order_by_param(@sort)

    respond_to do |format|
      format.html
      format.js
    end
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

  def sort_label
    case @sort
    when 'most_liked'
      'Most Liked'
    when 'trending'
      'Trending'
    else
      'Newest'
    end
  end

  def set_sort_and_filters
    author = params[:author].to_s.gsub('@', '').strip
    text = params[:text].to_s.gsub('@', '').strip
    @filters = [author, text, params[:published_date]]
    @sort = params[:sort]
    @sort_label = sort_label
  end
end
