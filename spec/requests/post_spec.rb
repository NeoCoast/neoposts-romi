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
end
