class this.Util

  @show_flash = (message) ->
    $("#flash").html(message)
    $("#flash").show()
    setTimeout ( -> Util.close_flash()), 1300

  @close_flash = ->
    $("#flash").html("")
    $("#flash").hide("slow")

  @generate_random_id = (range) ->
    range ?= 10000
    Math.round(Math.random() * range)

