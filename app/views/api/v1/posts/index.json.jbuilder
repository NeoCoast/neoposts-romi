# frozen_string_literal: true

json.posts @posts do |post|
  json.extract! post, :id, :title, :body, :published_at, :likes_count
  json.comments_count post.comments.count
end
