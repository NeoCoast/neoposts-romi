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
  $('#followers-list').addClass('hidden');
  $('#following-list').addClass('hidden');

  $(document).on('click', '#post-count', function() {
    togglePanel('#users-posts', '.post-count-container');
  });
  
  $(document).on('click', '#following-count', function() {
    togglePanel('#following-list', '#following-container');
  });
  
  $(document).on('click', '#followers-count', function() {
    togglePanel('#followers-list', '#followers-container');
  });
  
  function togglePanel(panelToShow, containerToUnderline) {
    var usersPostsShown = !$('#users-posts').hasClass('hidden');
  
    if (panelToShow === '#users-posts' && usersPostsShown) {
      return;
    }

    $('#users-posts').removeClass('hidden');
    $('.panel').addClass('hidden');
    $(panelToShow).removeClass('hidden');
  
    $('.container').removeClass('underlined');
    $(containerToUnderline).addClass('underlined');
  }

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

  var sort = $('#hidden-sort-field').val();

  $(document).on('click', '.sort-option', function (){
    sort = $(this).data('sort');
    $('#hidden-sort-field').val(sort);
  });

  $(document).on('click', '#clear-filters-button', function (){
    $('.author-filter').val('');
    $('.text-filter').val('');
    $('input[name="published_date"]').prop('checked', false);
    var author = $('.author-filter').val();
    var text = $('.text-filter').val();
    var publishedDate = $('input[name="published_date"]:checked').val();

    $.ajax({
      url: '/',
      type: 'GET',
      data: {
        author: author,
        text: text,
        published_date: publishedDate,
        sort: sort
      },
      dataType: 'script'
    });
  })
});
