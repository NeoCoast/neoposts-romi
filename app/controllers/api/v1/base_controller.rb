# frozen_string_literal: true

module Api
  module V1
    class BaseController < ActionController::API
      include DeviseTokenAuth::Concerns::SetUserByToken
      before_action :authenticate_user!, unless: :devise_controller?

      rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

      private

      def record_not_found
        render json: { message: 'Unauthorized' }, status: :unauthorized
      end
    end
  end
end
