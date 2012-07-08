# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
log = () ->
  console.log arguments... if console

$ ->
  search_list = $(".entity").map (i, element) ->
    name: $(element).find(".name").text(),
    element: $(element)

  search_box = $(".quick-search input[type='text']")
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
