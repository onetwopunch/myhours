class Profile
  constructor: ->
    $('.date-picker').datepicker()
    $('#calendar').fullCalendar({
      	height: 500,
      	theme: true,
      	dayClick: @day_click
      	
      })
    @bind_user_details_submit()
    @bind_create_entry()
  day_click: (date, jsEvent, view) ->
    #TODO: implement this
    alert "You just clicked on #{date.format()}"
    
  bind_create_entry: ->
    $(".create-entry").click () ->
      categories = $.map $('.entry-category'), (n, i) ->
        return { 'val': $(n).val(), 'id': $(n).prop('id')} if $(n).val() != ""
      console.log categories
      
      subcategories = $.map $('.entry-subcategory'), (n, i) ->
        [parent, id] = $(n).prop('id').split(':')
        return { 'val': $(n).val(), 'id': id, 'parent': parent} if $(n).val() != ""
      console.log subcategories
      
      $.post '/profile/add_entry',
        categories: categories
        subcategories: subcategories
        (data) ->
          console.log data.success
          $('#entry-form-modal').modal('hide')
      
  bind_user_details_submit: ->
    $('.user-info-submit').click () ->
      $(this).parent().parent().find('form').submit()
@Profile = Profile