class Profile
  constructor: ->
    if gon.new_user == true
      $('#user-info-modal').modal('show')
    $('.date-picker').datepicker()
    $('#calendar').fullCalendar({
        height: 500,
        theme: true,
        dayClick: @day_click,
        eventClick: @event_click,
        events: gon.entries
      })
    @bind_user_details_submit()
    @bind_create_entry()
    new SitesManager()
    
  day_click: (date, jsEvent, view) ->
    fdate = moment(date.format()).format("MM/DD/YYYY")
    $('#entry_date').val(fdate)
    $('#entry-form-modal').modal('show')
    
    $('#entry-form-modal').on 'hidden.bs.modal', (e) ->
      $('#entry_date').val(moment().format("MM/DD/YYYY"))
      
  event_click: (calEvent, jsEvent, view) ->
    alert calEvent.id
    
  
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
        date: $('#entry_date').val()
        site: $('#entry_site').find('option:selected').val()
        (data) ->
          if data.success == true
            console.log data
            gon.entries.push(data.entry)
            $('#calendar').fullCalendar('refetchEvents')
            $('.progress-container').html(data.progress)
          $('#entry-form-modal').modal('hide')
      
  
  bind_user_details_submit: ->
    $('.user-info-submit').click () ->
      $(this).parent().parent().find('form').submit()
  
  
  
  
  
@Profile = Profile