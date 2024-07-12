# frozen_string_literal: true

json.extract! @post, :id, :title, :body, :published_at, :user_id

json.likes @post.likes do |like|
  json.user_id like.user_id
  json.nickname like.user.nickname
end

json.comments @post.comments do |comment|
  json.partial!('comment', comment:)

  json.replies comment.comments do |reply|
    json.partial! 'comment', comment: reply
  end
end
