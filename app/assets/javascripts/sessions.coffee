$(document).ready ->
	$('#login_form').on 'submit',(event) -> 
			event.preventDefault()
			$.ajax $(this).attr('action'),
				type: 'POST'
				data: $(this).serialize()
				beforeSend: ->
						$('#status').html('loading...')
				error: (jqXHR, textStatus, errorThrown) -> 
						alert(textStatus)
				success: (data, textStatus, jqXHR) -> 
					if data.success 
						$('#status').html('redirecting')
						$('#status').fadeIn(500);
						true
					else 
						html = '<ul>'
						$('#status').html('errors')
						$('#error_report').fadeIn(500);
						html += "<li>" + errorMsg + "</li>" for errorMsg in data.message
						html += '</ul>'
						$('#error_report').html(html)
						false
					
