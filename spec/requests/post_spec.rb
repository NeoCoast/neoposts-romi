# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Posts', type: :request do
  describe 'SHOW post' do
    context 'when user is authenticated' do
      let!(:user) { create(:user) }
      let(:post) { create(:post) }

      before do
        sign_in user
      end

      it 'returns HTTP success' do
        get post_path(post)
        expect(response).to be_successful
      end

      it 'shows created post' do
        get post_path(post)
        expect(response.body).to include(post.body)
      end
    end

    context 'when user is not authenticated' do
      let(:post) { create(:post) }

      it 'redirects to sign in' do
        get post_path(post)
        expect(response).to redirect_to(user_session_path)
      end
    end
  end

  describe 'GET index' do
    context 'when user is authenticated' do
      let!(:users) { create_list(:user, 3) }
      let!(:posts_user0) { create_list(:post, 3, :liked_and_commented, user: users[0]) }
      let!(:posts_user1) { create_list(:post, 3, :liked_and_commented, user: users[1]) }
      let!(:posts_user2) { create_list(:post, 3, :liked_and_commented, user: users[2]) }

      before do
        sign_in users[0]
        users[0].follow(users[1])
        create(:like, likable: posts_user1[0])
        create(:like, likable: posts_user1[1])
        create(:like, likable: posts_user1[1])
      end

      context 'when no sort params are selected or user sorts by published date' do
        it 'returns HTTP success' do
          get root_path
          expect(response).to be_successful
        end

        it 'shows created posts' do
          get root_path
          posts_user1.each do |post|
            expect(response.body).to include(post.body)
          end
        end

        it 'shows followed user posts ordered by the newest created' do
          get root_path
          expect(assigns(:posts)).to eq(posts_user1.sort_by(&:published_at).reverse)
        end

        it 'shows followed user posts ordered by the newest created (with sort param)' do
          get root_path(sort: 'newest_created')
          expect(assigns(:posts)).to eq(posts_user1.sort_by(&:published_at).reverse)
        end

        it 'doesn`t show not followed user posts' do
          get root_path
          expect(assigns(:posts)).not_to include(posts_user2)
        end

        it 'doesn`t show logged user posts' do
          get root_path
          expect(assigns(:posts)).not_to include(posts_user0)
        end
      end

      context 'when user sorts by most liked' do
        it 'returns HTTP success' do
          get root_path(sort: 'most_liked')
          expect(response).to be_successful
        end

        it 'shows created posts' do
          get root_path(sort: 'most_liked')
          posts_user1.each do |post|
            expect(response.body).to include(post.body)
          end
        end

        it 'shows followed user posts ordered by the most liked' do
          get root_path(sort: 'most_liked')
          expect(assigns(:posts)).to eq(posts_user1.sort_by(&:likes_count).reverse)
        end

        it 'doesn`t show not followed user posts' do
          get root_path(sort: 'most_liked')
          expect(assigns(:posts)).not_to include(posts_user2)
        end

        it 'doesn`t show logged user posts' do
          get root_path(sort: 'most_liked')
          expect(assigns(:posts)).not_to include(posts_user0)
        end
      end

      context 'when user sorts by trending' do
        it 'returns HTTP success' do
          get root_path(sort: 'trending')
          expect(response).to be_successful
        end

        it 'shows created posts' do
          get root_path(sort: 'trending')
          posts_user1.each do |post|
            expect(response.body).to include(post.body)
          end
        end

        it 'shows followed user posts ordered by trending' do
          get root_path(sort: 'trending')
          trending_posts = users[1].posts.order_by_param('trending')
          expect(assigns(:posts)).to eq(trending_posts)
        end

        it 'doesn`t show not followed user posts' do
          get root_path(sort: 'trending')
          expect(assigns(:posts)).not_to include(posts_user2)
        end

        it 'doesn`t show logged user posts' do
          get root_path(sort: 'trending')
          expect(assigns(:posts)).not_to include(posts_user0)
        end
      end

      context 'when no sort params are selected' do
        it 'returns HTTP success' do
          get root_path
          expect(response).to be_successful
        end

        it 'shows created posts' do
          get root_path
          posts_user1.each do |post|
            expect(response.body).to include(post.body)
          end
        end

        it 'shows followed user posts ordered by the newest created' do
          get root_path
          expect(assigns(:posts)).to eq(posts_user1.sort_by(&:published_at).reverse)
        end

        it 'doesn`t show not followed user posts' do
          get root_path
          expect(assigns(:posts)).not_to include(posts_user2)
        end

        it 'doesn`t show logged user posts' do
          get root_path
          expect(assigns(:posts)).not_to include(posts_user0)
        end
      end
    end

    context 'when user is not authenticated' do
      let!(:post) { create(:post) }

      it 'redirects to sign in' do
        get root_path
        expect(response).to redirect_to(user_session_path)
      end
    end
  end

  describe 'NEW post' do
    context 'when user is authenticated' do
      let!(:user) { create(:user) }
      let(:post) { create(:post) }

      before do
        sign_in user
      end

      it 'returns HTTP success' do
        get post_path(post)
        expect(response).to be_successful
      end

      it 'creates a new Post' do
        get '/posts/new'
        expect(response).to render_template(:new)
      end
    end

    context 'when user is not authenticated' do
      let(:post) { create(:post) }

      it 'redirects to sign in' do
        get post_path(post)
        expect(response).to redirect_to(user_session_path)
      end
    end
  end

  describe 'CREATE post' do
    context 'when user is authenticated' do
      let!(:user) { create(:user) }
      let(:existingpost) { create(:post) }

      before do
        sign_in user
      end

      it 'returns HTTP success' do
        get post_path(existingpost)
        expect(response).to be_successful
      end

      context 'when the creation data is valid' do
        let(:post_attributes) { attributes_for(:post) }

        it 'creates a post' do
          expect do
            post posts_path, params: { post: post_attributes }
          end.to change(Post, :count).by(1)
        end

        it 'redirects to the new post' do
          post posts_path, params: { post: attributes_for(:post) }
          expect(response).to redirect_to(post_path(Post.last))
        end
      end

      context 'when the creation data is not valid' do
        it 'does not create a post' do
          expect do
            post posts_path, params: { post: { title: '', body: '', image: nil } }
          end.not_to change(Post, :count)
        end

        it 'renders the new template' do
          post posts_path, params: { post: { title: '', body: '', image: nil } }
          expect(response).to render_template(:new)
        end
      end
    end

    context 'when user is not authenticated' do
      let(:post) { create(:post) }

      it 'redirects to sign in' do
        get post_path(post)
        expect(response).to redirect_to(user_session_path)
      end
    end
  end

  describe 'DESTROY post' do
    context 'when user is authenticated' do
      let!(:users) { create_list(:user, 3) }
      let!(:post) { create(:post, :liked_and_commented, user: users[0]) }
      let!(:post2) { create(:post, :liked_and_commented, user: users[1]) }

      before do
        sign_in users[0]
      end

      context 'user tries to delete his post' do
        it 'deletes the post' do
          expect do
            delete post_path(post.id), params: { id: post.id }
          end.to change(Post, :count).by(-1)
        end

        it 'deletes associated comments' do
          expect do
            delete post_path(post.id), params: { id: post.id }
          end.to change(Comment, :count).by(-2)
        end

        it 'deletes associated likes' do
          expect do
            delete post_path(post.id), params: { id: post.id }
          end.to change(Like, :count).by(-1)
        end

        it 'redirects to the root path' do
          delete post_path(post.id), params: { id: post.id }
          expect(response).to redirect_to(root_path)
        end
      end

      context 'user tries to delete other user post' do
        it 'does not delete the post' do
          expect do
            delete post_path(post2.id), params: { id: post2.id }
          end.not_to change(Post, :count)
        end

        it 'does not delete associated comments' do
          expect do
            delete post_path(post2.id), params: { id: post2.id }
          end.not_to change(Comment, :count)
        end

        it 'does not delete associated likes' do
          expect do
            delete post_path(post2.id), params: { id: post2.id }
          end.not_to change(Like, :count)
        end

        it 'redirects to root path' do
          delete post_path(post2.id), params: { id: post2.id }
          expect(response).to redirect_to(root_path)
        end
      end
    end
  end
end
