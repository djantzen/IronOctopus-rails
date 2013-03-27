class this.Util
  SECOND = 1000
  @show_flash = (message, timeout) ->
    $("#flash").html(message)
    $("#flash").show()
    setTimeout ( -> Util.close_flash()), (timeout || 1.3 * SECOND)

  @close_flash = ->
    $("#flash").html("")
    $("#flash").hide("slow")

  @generate_random_id = (range) ->
    range ?= 10000
    Math.round(Math.random() * range)

