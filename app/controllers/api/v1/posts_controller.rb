# frozen_string_literal: true

module Api
  module V1
    class PostsController < Api::V1::BaseController
      before_action :set_user, only: %i[index create]
      before_action :verify_current_user, only: :create

      def index
        @posts = @user.posts
      end

      def show
        @post = Post.find(params[:id])
      end

      def create
        @post = @user.posts.new(post_params)
        if @post.save
          render 'api/v1/posts/show', status: :created
        else
          render json: { errors: @post.errors.full_messages }, status: :bad_request
        end
      end

      private

      def post_params
        params.require(:post).permit(:title, :body)
      end

      def set_user
        @user = User.find(params[:user_id])
      end

      def verify_current_user
        return if @user == current_user

        render json: { message: 'Unauthorized' }, status: :unauthorized
      end
    end
  end
end
