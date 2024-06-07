# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Relationships', type: :request do
  describe 'create' do
    context 'when user is authenticated' do
      let!(:users) { create_list(:user, 2) }

      before do
        sign_in users[0]
      end

      it 'follows another user (through AJAX)' do
        expect do
          post relationships_path, params: { followed_id: users[1].id }, xhr: true
        end.to change(Relationship, :count).by(1)
      end

      it 'responds with JavaScript' do
        post relationships_path, params: { followed_id: users[1].id }, xhr: true
        expect(response.content_type).to eq('text/javascript; charset=utf-8')
        expect(response.body).to include('Unfollow')
      end

      it 'follows another user (through HTML)' do
        expect do
          post relationships_path, params: { followed_id: users[1].id }
        end.to change(Relationship, :count).by(1)
      end

      it 'responds with HTML' do
        post relationships_path, params: { followed_id: users[1].id }
        expect(response).to redirect_to(show_user_path(users[1].nickname))
        follow_redirect!
        expect(response.body).to include('Unfollow')
      end
    end

    context 'when user is not authenticated' do
      let!(:users) { create_list(:user, 2) }

      it 'redirects to sign in' do
        post relationships_path, params: { followed_id: users[1].id }
        expect(response).to redirect_to(user_session_path)
      end
    end
  end

  describe 'destroy' do
    context 'when user is authenticated' do
      let!(:users) { create_list(:user, 2) }

      before do
        sign_in users[0]
        post relationships_path, params: { followed_id: users[1].id }
        @relationship = users[0].active_relationships.find_by(followed_id: users[1].id)
      end

      it 'unfollows another user (through AJAX)' do
        expect do
          delete relationship_path(@relationship), xhr: true
        end.to change(Relationship, :count).by(-1)
      end

      it 'responds with JavaScript' do
        delete relationship_path(@relationship), xhr: true
        expect(response.content_type).to eq('text/javascript; charset=utf-8')
        expect(response.body).to include('Follow')
      end

      it 'unfollows another user (through HTML)' do
        expect do
          delete relationship_path(@relationship)
        end.to change(Relationship, :count).by(-1)
      end

      it 'responds with HTML' do
        delete relationship_path(@relationship)
        expect(response).to redirect_to(show_user_path(users[1].nickname))
        follow_redirect!
        expect(response.body).to include('Follow')
      end
    end
  end

  context 'when user is not authenticated' do
    let!(:users) { create_list(:user, 2) }

    before do
      sign_in users[0]
      post relationships_path, params: { followed_id: users[1].id }
      @relationship = users[0].active_relationships.find_by(followed_id: users[1].id)
      sign_out users[0]
    end

    it 'redirects to sign in' do
      delete relationship_path(@relationship), xhr: true
      expect(response).to redirect_to(user_session_path)
    end
  end
end
