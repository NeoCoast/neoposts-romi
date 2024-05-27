# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe 'SHOW user profile' do
    context 'when user is authenticated' do
      let!(:user) { create(:user) }
      let!(:posts) { create_list(:post, 3, user:) }

      before do
        sign_in user
      end

      it 'returns HTTP success' do
        get show_user_path(user.nickname)
        expect(response).to be_successful
      end

      it 'shows users profile information' do
        get show_user_path(user.nickname)
        expect(response.body).to include(user.first_name)
        expect(response.body).to include(user.birthday.strftime('%m/%d/%Y'))
      end

      it 'shows users posts count' do
        get show_user_path(user.nickname)
        expect(response.body).to include(user.posts.count.to_s)
      end

      it 'shows users posts' do
        get show_user_path(user.nickname)
        user.posts.each do |post|
          expect(response.body).to include(post.body)
        end
      end
    end

    context 'when user is not authenticated' do
      let!(:user) { create(:user) }

      before do
        sign_out user
      end

      it 'redirects to sign in' do
        get show_user_path(user.nickname)
        expect(response).to redirect_to(user_session_path)
      end
    end
  end
end
