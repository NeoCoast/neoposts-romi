# frozen_string_literal: true

module Api
  module V1
    class PostsController < Api::V1::BaseController
      def index
        @posts = User.find(params[:user_id]).posts
      end
    end
  end
end
