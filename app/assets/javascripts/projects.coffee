# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
#
$(document).on "turbolinks:load", ->
    fixHelperModified = (e, tr) ->
      $originals = tr.children()
      $helper = tr.clone()
      $helper.children().each (index) ->
        $(this).width $originals.eq(index).width()
        return
      $helper

    jQuery ->
        $('#projects_table tbody').sortable(
          cursor: 'move'
          helper: fixHelperModified
          axis: 'y'
          update: ->
            $.post($(this).data('update-url'), $(this).sortable('serialize'))
        )

