# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::PostsController, type: :request do
  describe 'GET #index' do
    let!(:users) { create_list(:user, 2) }
    let!(:posts_user0) { create_list(:post, 3, :liked_and_commented, user: users[0]) }
    let!(:posts_user1) { create_list(:post, 3, :liked_and_commented, user: users[1]) }

    context 'when user is authenticated' do
      let(:auth_headers) { users[0].create_new_auth_token }

      context 'when user exists' do
        before do
          sign_in users[0]
          get api_v1_user_posts_path(users[1]), headers: auth_headers
        end

        it 'returns http success' do
          expect(response).to have_http_status(:success)
        end

        it 'JSON body response contains all user posts' do
          json_response = JSON.parse(response.body)
          expect(json_response['posts'].size).to eq(users[1].posts.size)
        end

        it 'JSON body response contains expected post attributes' do
          users[1].posts.each do |post|
            expect(response.body).to include(
              post.id.to_s,
              post.title,
              post.body,
              post.published_at.strftime('%Y-%m-%d'),
              post.comments.count.to_s,
              post.likes_count.to_s
            )
          end
        end
      end

      context 'when user does not exist' do
        before do
          get api_v1_user_posts_path('non_existing'), headers: auth_headers
        end

        it 'returns a not found response' do
          expect(response).to have_http_status(:not_found)
        end

        it 'returns an error message' do
          json_response = JSON.parse(response.body)
          expect(json_response['message']).to eq('User not found')
        end
      end
    end

    context 'when user is not authenticated' do
      before do
        get api_v1_user_posts_path(users[1])
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
