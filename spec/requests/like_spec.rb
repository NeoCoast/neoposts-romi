# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Likes', type: :request do
  describe 'create' do
    let!(:user) { create(:user) }
    let!(:newpost) { create(:post) }

    context 'when user likes a post' do
      before do
        sign_in user
      end

      it 'likes post (through AJAX)' do
        expect do
          post likes_path, params: { likable_type: newpost.class.name, likable_id: newpost.id }, xhr: true
        end.to change(Like, :count).by(1)
      end

      it 'responds with JavaScript' do
        post likes_path, params: { likable_type: newpost.class.name, likable_id: newpost.id }, xhr: true
        expect(response.content_type).to eq('text/javascript; charset=utf-8')
      end

      it 'likes post (through HTML)' do
        expect do
          post likes_path, params: { likable_type: newpost.class.name, likable_id: newpost.id }
        end.to change(Like, :count).by(1)
      end

      it 'responds with HTML' do
        post likes_path, params: { likable_type: newpost.class.name, likable_id: newpost.id }
        expect(response.body).to include('1')
      end

      it 'has the correct attributes' do
        post likes_path, params: { likable_type: newpost.class.name, likable_id: newpost.id }, xhr: true
        like = Like.last
        expect(like.user_id).to eq(user.id)
        expect(like.likable_id).to eq(newpost.id)
        expect(like.likable_type).to eq(newpost.class.name)
      end
    end

    context 'when user likes a comment' do
      let!(:comment) { create(:comment_of_a_post) }

      before do
        sign_in user
      end

      it 'likes post (through AJAX)' do
        expect do
          post likes_path, params: { likable_type: comment.class.name, likable_id: comment.id }, xhr: true
        end.to change(Like, :count).by(1)
      end

      it 'responds with JavaScript' do
        post likes_path, params: { likable_type: comment.class.name, likable_id: comment.id }, xhr: true
        expect(response.content_type).to eq('text/javascript; charset=utf-8')
      end

      it 'likes post (through HTML)' do
        expect do
          post likes_path, params: { likable_type: comment.class.name, likable_id: comment.id }
        end.to change(Like, :count).by(1)
      end

      it 'responds with HTML' do
        post likes_path, params: { likable_type: comment.class.name, likable_id: comment.id }
        expect(response.body).to include('1')
      end

      it 'has the correct attributes' do
        post likes_path, params: { likable_type: comment.class.name, likable_id: comment.id }, xhr: true
        like = Like.last
        expect(like.user_id).to eq(user.id)
        expect(like.likable_id).to eq(comment.id)
        expect(like.likable_type).to eq(comment.class.name)
      end
    end
  end
end
