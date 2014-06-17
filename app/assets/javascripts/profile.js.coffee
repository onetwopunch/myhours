class Profile
  constructor: ->
    $('.date-picker').datepicker()
    $('#calendar').fullCalendar({
      	height: 500,
      	theme: true
      })
    @bind_user_details_submit()
    
    
  bind_user_details_submit: ->
    $('.user-info-submit').click () ->
      $(this).parent().parent().find('form').submit()
@Profile = Profile