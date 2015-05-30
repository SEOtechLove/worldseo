# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery(document).ready ->
  offset = 250
  duration = 300
  jQuery(window).scroll ->
    if jQuery(this).scrollTop() > offset
      jQuery('.back-to-top').fadeIn duration
    else
      jQuery('.back-to-top').fadeOut duration
    return
  jQuery('.back-to-top').click (event) ->
    event.preventDefault()
    jQuery('html, body').animate { scrollTop: 0 }, duration
    false
  return
