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

  describe 'EDIT user profile' do
    context 'when user is authenticated' do
      let!(:user) { create(:user) }
      let(:user_attributes) do
        attributes_for(:user).merge(current_password: user.password)
      end

      before do
        sign_in user
      end

      it 'returns HTTP success' do
        get edit_user_registration_path
        expect(response).to be_successful
      end

      it 'edits user information' do
        put user_registration_path, params: { user: user_attributes }

        user.reload

        expect(user.email).to eq(user_attributes[:email])
        expect(user.first_name).to eq(user_attributes[:first_name])
        expect(user.last_name).to eq(user_attributes[:last_name])
        expect(user.nickname).to eq(user_attributes[:nickname])
        expect(user.birthday).to eq(user_attributes[:birthday])
        expect(response).to redirect_to(root_path)
      end

      it 'shows edited user' do
        put user_registration_path, params: { user: user_attributes }

        user.reload
        get show_user_path(user.nickname)

        expect(response.body).to include(user_attributes[:first_name])
        expect(response.body).to include(user_attributes[:last_name])
        expect(response.body).to include(user_attributes[:nickname])
        expect(response.body).to include(user_attributes[:birthday].strftime('%m/%d/%Y'))
      end
    end

    context 'when user is not authenticated' do
      let!(:user) { create(:user) }

      before do
        sign_out user
      end

      it 'redirects to sign in' do
        get edit_user_registration_path
        expect(response).to redirect_to(user_session_path)
      end
    end
  end

  describe 'GET index' do
    let!(:users) { create_list(:user, 8) }
    let!(:user) { users.first }

    context 'when user is authenticated' do
      before do
        sign_in user
      end

      context 'searching for all users' do
        it 'returns HTTP success' do
          get users_path
          expect(response).to be_successful
        end

        it 'shows user list' do
          total_pages = User.page.total_pages
          (1..total_pages).each do |page|
            get users_path, params: { page: }
            users_on_page = User.order(:first_name).page(page).per(User.default_per_page)
            users_on_page.each do |user|
              expect(response.body).to include(user.nickname)
              expect(response.body).to include(user.first_name)
              expect(response.body).to include(user.last_name)
            end
          end
        end
      end

      context 'searching for a user by nickname' do
        it 'search param with @ shows user' do
          get users_path, params: { search: "@#{users[2].nickname}" }
          expect(response).to have_http_status(:success)
          expect(response.body).to include(user.nickname)
          expect(response.body).to include(user.first_name)
          expect(response.body).to include(user.last_name)
        end

        it 'search param with trailing spaces shows user' do
          get users_path, params: { search: "  #{users[2].nickname}  " }
          expect(response).to have_http_status(:success)
          expect(response.body).to include(user.nickname)
          expect(response.body).to include(user.first_name)
          expect(response.body).to include(user.last_name)
        end

        it 'search param just nickname shows user' do
          get users_path, params: { search: users[2].nickname.to_s }
          expect(response).to have_http_status(:success)
          expect(response.body).to include(user.nickname)
          expect(response.body).to include(user.first_name)
          expect(response.body).to include(user.last_name)
        end

        it 'search param nickname capitalized shows user' do
          get users_path, params: { search: users[2].nickname.capitalize!.to_s }
          expect(response).to have_http_status(:success)
          expect(response.body).to include(user.nickname)
          expect(response.body).to include(user.first_name)
          expect(response.body).to include(user.last_name)
        end
      end

      context 'searching for a user by firstname' do
        it 'search param with @ shows user' do
          get users_path, params: { search: "@#{users[2].first_name}" }
          expect(response).to have_http_status(:success)
          expect(response.body).to include(user.nickname)
          expect(response.body).to include(user.first_name)
          expect(response.body).to include(user.last_name)
        end

        it 'search param with trailing spaces shows user' do
          get users_path, params: { search: "  #{users[2].first_name}  " }
          expect(response).to have_http_status(:success)
          expect(response.body).to include(user.nickname)
          expect(response.body).to include(user.first_name)
          expect(response.body).to include(user.last_name)
        end

        it 'search param just firstname shows user' do
          get users_path, params: { search: users[2].first_name.to_s }
          expect(response).to have_http_status(:success)
          expect(response.body).to include(user.nickname)
          expect(response.body).to include(user.first_name)
          expect(response.body).to include(user.last_name)
        end

        it 'search param firstname capitalized shows user' do
          get users_path, params: { search: users[2].first_name.capitalize!.to_s }
          expect(response).to have_http_status(:success)
          expect(response.body).to include(user.nickname)
          expect(response.body).to include(user.first_name)
          expect(response.body).to include(user.last_name)
        end
      end

      context 'searching for a user by lastname' do
        it 'search param with @ shows user' do
          get users_path, params: { search: "@#{users[2].last_name}" }
          expect(response).to have_http_status(:success)
          expect(response.body).to include(user.nickname)
          expect(response.body).to include(user.first_name)
          expect(response.body).to include(user.last_name)
        end

        it 'search param with trailing spaces shows user' do
          get users_path, params: { search: "  #{users[2].last_name}  " }
          expect(response).to have_http_status(:success)
          expect(response.body).to include(user.nickname)
          expect(response.body).to include(user.first_name)
          expect(response.body).to include(user.last_name)
        end

        it 'search param just lastname shows user' do
          get users_path, params: { search: users[2].last_name.to_s }
          expect(response).to have_http_status(:success)
          expect(response.body).to include(user.nickname)
          expect(response.body).to include(user.first_name)
          expect(response.body).to include(user.last_name)
        end

        it 'search param lastname capitalized shows user' do
          get users_path, params: { search: users[2].last_name.capitalize!.to_s }
          expect(response).to have_http_status(:success)
          expect(response.body).to include(user.nickname)
          expect(response.body).to include(user.first_name)
          expect(response.body).to include(user.last_name)
        end
      end
    end

    context 'when user is not authenticated' do
      before do
        sign_out user
      end

      it 'redirects to sign in' do
        get users_path
        expect(response).to redirect_to(user_session_path)
      end
    end
  end
end
