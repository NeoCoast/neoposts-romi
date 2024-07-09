# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :request do
  describe 'GET #index' do
    let!(:users) { create_list(:user, 3) }

    context 'when user is authenticated' do
      let(:auth_headers) { users[0].create_new_auth_token }

      before do
        sign_in users[0]
        get api_v1_users_path, headers: auth_headers
      end

      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end

      it 'JSON body response contains all users' do
        json_response = JSON.parse(response.body)
        expect(json_response['users'].size).to eq(users.size)
      end

      it 'JSON body response contains expected user attributes' do
        users.each do |user|
          expect(response.body).to include(
            user.id.to_s,
            user.email,
            user.nickname,
            user.first_name,
            user.last_name,
            user.birthday.strftime('%Y-%m-%d')
          )
        end
      end
    end

    context 'when user is not authenticated' do
      before do
        get api_v1_users_path
      end

      it 'returns http unauthorized' do
        expect(response.status).to eq(401)
      end

      it 'JSON body response indicates that authentication is required' do
        expect(response.body).to include('You need to sign in or sign up before continuing.')
      end
    end
  end
end
