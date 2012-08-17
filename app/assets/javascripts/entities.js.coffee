# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
window.DH = {}

DH = window.DH

DH.log = () ->
  console.log arguments... if console

$ ->
  # SET UP QUICKSEARCH
  search_box = $(".quick-search input[type='text']")

  if search_box
    search_list = $(".entity").map (i, element) ->
      name: $(element).find(".name").text(),
      element: $(element)

    search_box.on "keyup", (event) ->
      for item in search_list
        if item.name.indexOf(search_box.val()) > -1
          item.element.show()
        else
          item.element.hide()
      # hide sections with no more visible children
      $(".section").each (i, section) ->
        if $(section).children().is(".entity:visible")
          $(section).find(".heading").show()
        else
          $(section).find(".heading").hide()

  # SET UP ENTITY COMPLETIONS
  $field = $(".mention")

  if $field
    # find entity type; looks wasteful, but id lookup is extremely fast
    for type in ["character", "city", "region", "group"]
      $hidden = $("##{type}_description")
      break if $hidden.length > 0

    $field.val $hidden.val()

    $field.mentionsInput
      useCurrentVal: true,
      onDataRequest: (mode, query, callback) ->
        data = _(completions).select (item) ->
          item.name.toLowerCase().indexOf(query.toLowerCase()) > -1
        callback.call(this, data)

    $field.on "focusout", ->
      $field.mentionsInput "val", (value) ->
        $hidden.val value

    # debug methods
    DH.mention_value = ->
      $field.mentionsInput "val", (value) -> DH.log value
