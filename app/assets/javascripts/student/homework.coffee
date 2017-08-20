$(document).ready ->
	$('.sub-drop-down').on 'click', (event) -> 
		event.preventDefault()
		elem = $('#submission_box' + $(this).attr('data-id'))
		if elem.css('display') == 'block'
			elem.slideUp(500)
		else
			elem.slideDown(500)

