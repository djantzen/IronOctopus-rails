$(document).ready ->
  $("form.new_work").validate(
    submitHandler: (form, event) ->
#      form.remove()
      form.submit()
      $(form).parents(".collapse").collapse("hide")
      return false
  )

  $("form.new_work").submit (e)->
#    alert("submit")
#    $(this).remove();
#    $(this).parents(".collapse").collapse("hide");
#    e.preventDefault
#    form = $(this).parents("form")
#    return false

