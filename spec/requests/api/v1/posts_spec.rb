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
          expect(response).to have_http_status(:unauthorized)
        end

        it 'returns an error message' do
          json_response = JSON.parse(response.body)
          expect(json_response['message']).to eq('Unauthorized')
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

  describe 'GET #show' do
    let!(:users) { create_list(:user, 2) }
    let!(:post) { create(:post, :liked_and_commented, user: users[1]) }
    let!(:comment_replies) { create_list(:comment_of_a_comment, 2, commentable: post.comments.first, user: users[1]) }

    context 'when user is authenticated' do
      let(:auth_headers) { users[0].create_new_auth_token }

      context 'when user exists' do
        before do
          sign_in users[0]
          get api_v1_post_path(post), headers: auth_headers
        end

        it 'returns http success' do
          expect(response).to have_http_status(:success)
        end

        it 'JSON body response contains expected post attributes' do
          json_response = JSON.parse(response.body)
          expect(json_response).to include(
            'id' => post.id,
            'title' => post.title,
            'body' => post.body,
            'published_at' => post.published_at.as_json,
            'user_id' => post.user_id
          )

          expect(json_response['likes'].size).to eq(post.likes.size)
          post.likes.each do |like|
            expect(json_response['likes']).to include(
              'user_id' => like.user_id,
              'nickname' => like.user.nickname
            )
          end

          expect(json_response['comments'].size).to eq(post.comments.size)
          post.comments.each do |comment|
            expect(json_response['comments']).to include(
              'id' => comment.id,
              'body' => comment.content,
              'replies' => comment.comments.map { |reply| { 'id' => reply.id, 'body' => reply.content } }
            )
          end
        end
      end

      context 'when post does not exist' do
        before do
          get api_v1_post_path('non_existing'), headers: auth_headers
        end

        it 'returns a not found response' do
          expect(response).to have_http_status(:unauthorized)
        end

        it 'returns an error message' do
          json_response = JSON.parse(response.body)
          expect(json_response['message']).to eq('Unauthorized')
        end
      end
    end

    context 'when user is not authenticated' do
      before do
        get api_v1_post_path(post)
      end

      it 'returns http unauthorized' do
        expect(response.status).to eq(401)
      end

      it 'JSON body response indicates that authentication is required' do
        expect(response.body).to include('You need to sign in or sign up before continuing.')
      end
    end
  end

  describe 'POST #create' do
    let!(:users) { create_list(:user, 2) }
    let(:post_attributes) { attributes_for(:post) }

    context 'when user is authenticated' do
      let(:auth_headers) { users[0].create_new_auth_token }

      context 'when user exists' do
        context 'when logged user creates a post with valid attributes' do
          before do
            sign_in users[0]
            post api_v1_user_posts_path(users[0]), params: { post: post_attributes }, headers: auth_headers
          end

          it 'returns http created' do
            expect(response).to have_http_status(:created)
          end

          it 'creates a new post' do
            expect do
              post api_v1_user_posts_path(users[0]), params: { post: post_attributes }, headers: auth_headers
            end.to change(Post, :count).by(1)
          end

          it 'returns the correct post attributes in the response' do
            json_response = JSON.parse(response.body)
            expect(json_response).to include(
              'title' => post_attributes[:title],
              'body' => post_attributes[:body]
            )
          end
        end

        context 'when logged user creates a post with invalid attributes' do
          let(:invalid_post_attributes) { { title: '', body: '' } }

          before do
            sign_in users[0]
            post api_v1_user_posts_path(users[0]), params: { post: invalid_post_attributes }, headers: auth_headers
          end

          it 'returns http created' do
            expect(response).to have_http_status(:bad_request)
          end

          it 'does not create a new post' do
            expect do
              post api_v1_user_posts_path(users[0]), params: { post: invalid_post_attributes }, headers: auth_headers
            end.not_to change(Post, :count)
          end

          it 'returns the validation errors in the response' do
            json_response = JSON.parse(response.body)
            expect(json_response['errors']).to include(
              "Title can't be blank",
              "Body can't be blank"
            )
          end
        end

        context 'when trying to create a post for a user different to the logged one' do
          before do
            sign_in users[0]
            post api_v1_user_posts_path(users[1]), params: { post: post_attributes }, headers: auth_headers
          end

          it 'returns http unauthorized' do
            expect(response).to have_http_status(:unauthorized)
          end

          it 'JSON body response indicates that user is unauthorized' do
            expect(response.body).to include('Unauthorized')
          end
        end
      end

      context 'when user does not exist' do
        before do
          post api_v1_user_posts_path('non_existing'), params: { post: post_attributes }, headers: auth_headers
        end

        it 'returns a not found response' do
          expect(response).to have_http_status(:unauthorized)
        end

        it 'returns an error message' do
          json_response = JSON.parse(response.body)
          expect(json_response['message']).to eq('Unauthorized')
        end
      end
    end

    context 'when user is not authenticated' do
      before do
        post api_v1_user_posts_path(users[0]), params: { post: post_attributes }
      end

      it 'returns http unauthorized' do
        expect(response.status).to eq(401)
      end

      it 'JSON body response indicates that authentication is required' do
        expect(response.body).to include('You need to sign in or sign up before continuing.')
      end
    end
  end

  describe 'PUT #update' do
    let!(:users) { create_list(:user, 2) }
    let!(:post) { create(:post, :liked_and_commented, user: users[0]) }
    let!(:post_user1) { create(:post, :liked_and_commented, user: users[1]) }
    let(:post_attributes) { attributes_for(:post) }

    context 'when user is authenticated' do
      let(:auth_headers) { users[0].create_new_auth_token }

      context 'when user exists' do
        context 'when logged user updates a post with valid attributes' do
          before do
            sign_in users[0]
            put api_v1_post_path(post), params: { post: post_attributes }, headers: auth_headers
          end

          it 'returns http created' do
            expect(response).to have_http_status(:success)
          end

          it 'returns the correct post attributes in the response' do
            post.reload
            json_response = JSON.parse(response.body)
            expect(json_response).to include(
              'title' => post_attributes[:title],
              'body' => post_attributes[:body],
              'id' => post.id
            )
          end
        end

        context 'when logged user updates a post with invalid attributes' do
          let(:invalid_post_attributes) { { title: '', body: '' } }

          before do
            sign_in users[0]
            put api_v1_post_path(post), params: { post: invalid_post_attributes }, headers: auth_headers
          end

          it 'returns http created' do
            expect(response).to have_http_status(:bad_request)
          end

          it 'does not update post' do
            post.reload
            expect(post.title).not_to eq('')
            expect(post.body).not_to eq('')
          end

          it 'returns the validation errors in the response' do
            json_response = JSON.parse(response.body)
            expect(json_response['errors']).to include(
              "Title can't be blank",
              "Body can't be blank"
            )
          end
        end

        context 'when trying to update a post that does not belong to the logged user' do
          before do
            sign_in users[0]
            put api_v1_post_path(post_user1), params: { post: post_attributes }, headers: auth_headers
          end

          it 'returns http unauthorized' do
            expect(response).to have_http_status(:unauthorized)
          end

          it 'JSON body response indicates that user is unauthorized' do
            expect(response.body).to include('Unauthorized')
          end
        end
      end

      context 'when post does not exist' do
        before do
          put api_v1_post_path('non_existing'), params: { post: post_attributes }, headers: auth_headers
        end

        it 'returns a not found response' do
          expect(response).to have_http_status(:unauthorized)
        end

        it 'returns an error message' do
          json_response = JSON.parse(response.body)
          expect(json_response['message']).to eq('Unauthorized')
        end
      end
    end

    context 'when user is not authenticated' do
      before do
        put api_v1_post_path(post), params: { post: post_attributes }
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
