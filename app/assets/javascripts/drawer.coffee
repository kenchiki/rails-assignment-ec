# ドロワー
# $('#drawer').drawer({toggle_selector: '.drawer__toggle'});

$.fn.drawer = (config) ->
  switch_drawer = ->
    $body.toggleClass open_class
    $overlay = $('.' + overlay_class)
    if $overlay.length > 0
      $overlay.remove()
    else
      $overlay = $('<div />').attr('class', overlay_class)
      $('body').append $overlay
      $overlay.off 'touchend click'
      $overlay.on 'touchend click', arguments.callee
    false

  config = $.extend({ toggle_selector: '.drawer__toggle' }, config)
  $body = $('body')
  $toggle = $(config.toggle_selector)
  overlay_class = 'drawer__overlay'
  open_class = 'drawer__open'

  $toggle.off 'touchend click'
  $toggle.on 'touchend click', switch_drawer
  return

$(document).on 'turbolinks:load', ->
  $.fn.drawer toggle_selector: '.drawer__toggle'
  return