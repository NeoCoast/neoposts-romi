# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Post, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:body) }
  end

  describe 'scopes' do
    let!(:old_post) { create(:post, likes_count: 10) }
    let!(:trending_post) { create(:post, likes_count: 20) }
    let!(:new_post) { create(:post, likes_count: 5) }

    context 'order_by_param' do
      it 'orders by newest first' do
        expect(Post.order_by_param('')).to eq([new_post, trending_post, old_post])
      end

      it 'orders by most liked' do
        expect(Post.order_by_param('most_liked')).to eq([trending_post, old_post, new_post])
      end

      it 'orders by trending' do
        expect(Post.order_by_param('trending')).to eq([trending_post, old_post, new_post])
      end
    end

    context 'filter_by_param' do
      it 'filters by author' do
        author = old_post.user.nickname
        expect(Post.filter_by(author, '', '')).to eq([old_post])
      end

      it 'filters by title text' do
        expect(Post.filter_by('', new_post.title, '')).to eq([new_post])
      end

      it 'filters by body text' do
        expect(Post.filter_by('', new_post.body, '')).to eq([new_post])
      end

      it 'filters by date' do
        expect(Post.filter_by('', '', 'last_day')).to eq([old_post, trending_post, new_post])
      end
    end
  end
end
