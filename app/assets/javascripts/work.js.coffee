#$(document).ready ->
#  Gotta put a separate validator on each form for some reason
#  $("form.new_work").each (index, form) ->
#    $(form).validate(
#      submitHandler: (form) ->
#        if ($(form).valid())
#          $(form).find(".collapse").collapse("hide")
#          $(form).ajaxSubmit()
#        return true
#    )
#  $(".show-instructions").click () ->
#    $(this).find(".instructions-modal").modal();