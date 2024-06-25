//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require jquery3
//= require popper
//= require_tree .
//= require bootstrap

import 'bootstrap';
import Rails from '@rails/ujs'
import './add_jquery';
Rails.start();

document.addEventListener('DOMContentLoaded', function() {
    var followingClicked = false;
    var followersClicked = false;
  
    document.getElementById('following-count').addEventListener('click', function() {
      if (!followingClicked) {
        document.querySelector('.following-list').classList.remove('hidden');
        document.querySelector('.followers-list').classList.add('hidden');
        document.getElementById('users-posts').classList.add('hidden');
        followingClicked = true;
        followersClicked = false;
      } else {
        document.querySelector('.following-list').classList.add('hidden');
        document.querySelector('.followers-list').classList.add('hidden');
        document.getElementById('users-posts').classList.remove('hidden');
        followingClicked = false;
      }
    });

  document.getElementById('followers-count').addEventListener('click', function() {
    if (!followersClicked) {
      document.querySelector('.followers-list').classList.remove('hidden');
      document.querySelector('.following-list').classList.add('hidden');
      document.getElementById('users-posts').classList.add('hidden');
      followersClicked = true;
      followingClicked = false;
    } else {
      document.querySelector('.followers-list').classList.add('hidden');
      document.querySelector('.following-list').classList.add('hidden');
      document.getElementById('users-posts').classList.remove('hidden');
      followersClicked = false;
    }
  });

  $(document).on('click', '.toggle-postcomment-form', function() {
    const formId = `#postcomment-form-${this.dataset.postId}`;
    document.querySelector(formId).classList.toggle('hidden');
  })

  $(document).on('click', '.toggle-comments', function() {
    var postId = this.dataset.postId;
    document.querySelector('#comments-' + postId).classList.toggle('hidden');
  }) 

  $(document).on('click', '.toggle-commentscomment-form', function () {
    const formId = `#commentcomment-form-${this.dataset.commentId}`;
      document.querySelector(formId).classList.toggle('hidden');
  })
});

