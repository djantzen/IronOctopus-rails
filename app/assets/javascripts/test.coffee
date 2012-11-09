class window.Animal
  constructor: (@name) ->

  move: (meters) ->
    alert @name + " moved #{meters}m."


#parentEls = delete_button.parents().map ->
# return this.tagName + " " + this.className
#   .get().join(", ")
