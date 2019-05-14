# File used to set all notification status to 'read'
$(document).on 'ready turbolinks:change turbolinks:load', ->
  if (window.location.pathname == '/notifications')
    $.ajax '/notifications/read_all',
      type: 'PUT'

      # Security stuff
      beforeSend: (xhr) ->
        xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
      dataType: 'json'
      error: (jqXHR, textStatus, errorThrown) ->
        console.log("Update successful")
      success: (data, textStatus, jqXHR) ->
        alert('Error!')
