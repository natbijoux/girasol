---
---

class Chooseaproduct
  # Selects the content of a given element
  selectText: (element) ->
    if document.body.createTextRange
      range = document.body.createTextRange()
      range.moveToElementText(element)
      range.select()
    else if window.getSelection
      selection = window.getSelection()
      range = document.createRange()

      range.selectNodeContents(element)
      selection.removeAllRanges()
      selection.addRange(range)

  # Qtip position attributes for tooltips
  qtip_position:
    my: "top center"
    at: "bottom center"

  # Annotation rule types as defined in `_config.yml`
  ruletypes:
    required: "Required"
    permitted: "Permitted"
    forbidden: "Forbidden"

  # fire on document.ready
  constructor: ->
    @initTooltips()

  # Init tooltip action
  initTooltips: ->

    # Dynamically add annotations as title attribute to rule list items
    for ruletype, rules of window.annotations
      for rule in rules
        $(".product-rules ul.product-#{ruletype} li.#{rule["tag"]}").attr "title", rule["description"]

    # Init tooltips on all rule list items
    for ruletype, label of @ruletypes
      $(".product-#{ruletype} li").qtip
        content:
          text: false
          title:
            text: label
        position: @qtip_position
        style:
          classes: "qtip-shadow qtip-#{ruletype}"

    false


$ ->
  new Chooseaproduct()
