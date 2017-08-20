$(document).on 'turbolinks:load',->
	$('body').on 'click','.sub-drop-down', (event) -> 
		event.preventDefault()
		element = $('.'+ $(this).attr('data-target') + $(this).attr('data-id'))
		data = {}
		data[elem.nodeName] = elem.nodeValue for elem in this.attributes
		if element.css('display') == 'block'
			element.slideUp(500)
		else
			$.ajax $(this).attr('grab_point'),
					data: data
					beforeSend: ->
							element.slideDown(500)
							element.html('reloading...')
					error: (jqXHR, textStatus, errorThrown) -> 
							alert(textStatus)
					success: (data, textStatus, jqXHR) -> 
							element.html(data)

	$('body').on 'keyup','.search_box', (event) ->
			data = {}
			data[elem.nodeName] = elem.nodeValue for elem in this.attributes
			data['phrase'] = this.value
			$.ajax '/search',
				data: data
				beforeSend: ->
						$('.results').html('searching...')
				error: (jqXHR, textStatus, errorThrown) -> 
						alert(textStatus)
				success: (data, textStatus, jqXHR) -> 
						$('.results').html(data)
						true

	$('body').on 'click','.assign_button', (event) -> 
			event.preventDefault()
			data = {}
			data[elem.nodeName] = elem.nodeValue for elem in this.attributes
			data['due_date'] = $('#due_date').val()
			$.ajax $(this).attr('href'),
				type: 'POST'
				data: {assignment: data}
				beforeSend: ->
					$('.assignment_container').html('reloading...')
				error: (jqXHR, textStatus, errorThrown) -> 
						alert(textStatus)
				success: (data, textStatus, jqXHR) -> 
						$('.search_box').trigger('keyup')
						$('.assignment_container').html(data)
						true	

	return undefined		