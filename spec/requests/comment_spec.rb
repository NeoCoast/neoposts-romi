# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Comments', type: :request do
  describe 'POST #create' do
    let!(:user) { create(:user) }
    let!(:newpost) { create(:post) }

    context 'NEW post comment' do
      let(:comment_params) do
        attributes_for(:comment, commentable_type: newpost.class.name, commentable_id: newpost.id)
      end

      before do
        sign_in user
      end

      it 'creates a new Post Comment (through AJAX)' do
        expect do
          post comments_path, params: { comment: comment_params }, xhr: true
        end.to change(Comment, :count).by(1)
      end

      it 'responds with JavaScript' do
        post comments_path, params: { comment: comment_params }, xhr: true
        expect(response.content_type).to eq('text/javascript; charset=utf-8')
        expect(response.body).to include(comment_params[:content])
      end

      it 'creates a new Post Comment (through HTML)' do
        expect do
          post comments_path, params: { comment: comment_params }
        end.to change(Comment, :count).by(1)
      end

      it 'responds with HTML' do
        post comments_path, params: { comment: comment_params }
        expect(response.body).to include(comment_params[:content])
      end

      it 'has the correct attributes' do
        post comments_path, params: { comment: comment_params }, xhr: true
        comment = Comment.last
        expect(comment.content).to eq(comment_params[:content])
        expect(comment.user.id).to eq(user.id)
        expect(comment.commentable_id).to eq(comment_params[:commentable_id])
        expect(comment.commentable_type).to eq(comment_params[:commentable_type])
      end
    end

    context 'NEW comment comment' do
      let!(:parent_comment) { create(:comment, commentable: newpost, user:, content: 'Parent comment content') }
      let(:comment_params) do
        attributes_for(:comment, commentable_type: parent_comment.class.name, commentable_id: parent_comment.id)
      end

      before do
        sign_in user
      end

      it 'creates a new Post Comment (through AJAX)' do
        expect do
          post comments_path, params: { comment: comment_params }, xhr: true
        end.to change(Comment, :count).by(1)
      end

      it 'responds with JavaScript' do
        post comments_path, params: { comment: comment_params }, xhr: true
        expect(response.content_type).to eq('text/javascript; charset=utf-8')
        expect(response.body).to include(comment_params[:content])
      end

      it 'creates a new Post Comment (through HTML)' do
        expect do
          post comments_path, params: { comment: comment_params }
        end.to change(Comment, :count).by(1)
      end

      it 'responds with HTML' do
        post comments_path, params: { comment: comment_params }
        expect(response.body).to include(comment_params[:content])
      end

      it 'has the correct attributes' do
        post comments_path, params: { comment: comment_params }, xhr: true
        comment = Comment.last
        expect(comment.content).to eq(comment_params[:content])
        expect(comment.user.id).to eq(user.id)
        expect(comment.commentable_id).to eq(comment_params[:commentable_id])
        expect(comment.commentable_type).to eq(comment_params[:commentable_type])
      end
    end
  end
end
