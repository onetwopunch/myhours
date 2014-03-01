# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->

	post_to_show = (id) ->
		$.post '/profile/show',
	    entry_id: id
	    (data) -> 
	    	$('#desc-out').html(data['description'])
	    	$('#user-out').html(data['username'])
	    	$('#pass-out').html(data['password'])

	post_to_remove = (id) ->
		$.post '/profile/delete',
	    entry_id: id
	    (data) -> 
	    	$(".entry.selected").remove();

	
	post_to_create = (desc, un, pw) ->
		$.post '/profile/create',
	    description: desc
	    username: un
	    password: pw
	    (data) -> 
	    	$(".entry-box ul").prepend("<li class='entry' id='"+data['entry_id']+"'>"+data['description']+"</li>")
	    	entry_listener()

	entry_listener = () ->		
		$('.entry').click () ->
			$('.entry.selected').removeClass('selected')
			$(this).addClass('selected')

	entry_listener()

	$('#modal-show').click () ->
		str_id = $('.entry.selected').attr('id')
		console.log "Showing modal popup"	
		int_id = parseInt(str_id,10)
		post_to_show(int_id)

	$('#create-entry-submit').click () ->
		desc = $("input[id='description']").val()
		$("input[id='description']").val("")
		un = $("input[id='username']").val()
		$("input[id='username']").val("")
		pw = $("input[id='password']").val()
		$("input[id='password']").val("")	
		post_to_create(desc, un, pw)

	$('#show-entry').on 'hidden.bs.modal', () ->
		$('#desc-out').html('')
		$('#user-out').html('')
		$('#pass-out').html('')
		$.post '/profile/hide',
			(data) -> 
				console.log("password data removed from browser and server")

	$('#remove-entry').click () ->
		str_id = $('.entry.selected').attr('id')
		int_id = parseInt(str_id,10)
		post_to_remove(int_id)
