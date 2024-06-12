//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require jquery3
//= require popper
//= require_tree .

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
});

