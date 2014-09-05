class Profile
  constructor: ->
    new SitesManager()
    if gon.new_user == true
      $('#user-info-modal').modal('show')
      $('#user-info-modal').on 'hidden.bs.modal', (e) ->
        $('#manage-sites-modal').modal('show')
    
    $('.date-picker').datepicker()
    $('#calendar').fullCalendar({
        height: 500,
        theme: true,
        dayClick: @day_click,
        eventClick: @event_click,
        eventSources: [
          @event_source()
        ]
    })
    @bind_user_details_submit()
    @bind_create_entry()

    $('#entry-form-modal').on 'hidden.bs.modal', (e) ->
      $('.entry-category').val('')
      $('.entry-subcategory').val('')
  event_source: ->
    token = $('.hidden').data('private_token')
    "/api/users/entries?private_token=#{token}"
  day_click: (date, jsEvent, view) ->
    fdate = moment(date.format()).format("MM/DD/YYYY")
    $('#entry_date').val(fdate)
    $('#entry-form-modal').modal('show')
    $('#entry-form-modal').on 'hidden.bs.modal', (e) ->
      $('#entry_date').val(moment().format("MM/DD/YYYY"))
      $('.errors').html('')

  bind_entry_edit: ->
    _this = @
    $('#btn-edit-entry').click () ->
      $('#show-entry').hide()
      $('#edit-entry').show()
      _this.bind_entry_edit_submit()
      _this.bind_entry_delete()
      
  bind_entry_back: ->
    $('#btn-entry-back').click () ->
      $('#edit-entry').hide()
      $('#show-entry').show()
      
  event_click: (calEvent, jsEvent, view) =>
    console.log @
    _this = @
    console.log calEvent
    $.post '/profile/get_entry',
      entry_id: calEvent.id
      (data) ->
        console.log data
        if data.success == true
          $("#show-entry").html(data.show_html)
          $('#show-entry').show()
          $('#edit-entry').hide()
          $('#edit-entry').html(data.edit_html)
          $('#manage-entries-modal').modal('show')
          
          _this.bind_entry_edit()
          _this.bind_entry_back()
          
        else
          console.log "Entry with id = #{calEvent.id} does not exist"  
    
  
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
          console.log data
          if data.success == true
            $('#calendar').fullCalendar('refetchEvents')
            $('.progress-container').html(data.progress)
            $('#entry-form-modal').modal('hide')
          else
            $('.errors').html(data.errors)
            setTimeout () ->
              $('.errors').hide('slow')
              $('.errors').html('')
            , 5000
          
  bind_entry_edit_submit: ->
    $('#submit-edit-entry').click () ->
      categories = $.map $('.edit-entry-category'), (n, i) ->
        return { 'val': $(n).val(), 'id': $(n).prop('id')} if $(n).val() != ""
      console.log categories
      
      subcategories = $.map $('.edit-entry-subcategory'), (n, i) ->
        [parent, id] = $(n).prop('id').split(':')
        return { 'val': $(n).val(), 'id': id, 'parent': parent} if $(n).val() != ""
      console.log subcategories
      
      $.post '/profile/edit_entry',
        entry_id: $(this).data('entry-id')
        categories: categories
        subcategories: subcategories
        date: $('#edit_entry_date').val()
        site: $('#edit_entry_site').find('option:selected').val()
        (data) ->
          console.log data
          if data.success == true
            $('#calendar').fullCalendar('refetchEvents')
            $('.progress-container').html(data.progress)
            $('#manage-entries-modal').modal('hide')
          else
            $('.errors').html(data.errors)
            setTimeout () -> 
              $('.errors').hide('slow')
              $('.errors').html('')
            , 5000

  bind_entry_delete: ->
    $('#delete-entry').click () ->
      entry_id = $(this).data('entry-id')
      $.post '/profile/delete_entry',
        entry_id: entry_id 
        (data) ->
          if data.success == true
            $('#calendar').fullCalendar('refetchEvents')
            $('.progress-container').html(data.progress)
            $('#manage-entries-modal').modal('hide')
          else
            $('.errors').html(data.errors)
            setTimeout () -> 
              $('.errors').hide('slow')
              $('.errors').html('')
            , 5000

  bind_user_details_submit: ->
    $('.user-info-submit').click () ->
      url = '/profile/user_update'
      $.post url,
        first_name: $('input#first_name').val()
        last_name: $('input#last_name').val()
        grad_date: $('input#grad_date').val()
        (data) ->
          if data.success == true
            $('#user-info-modal').modal('hide')
            gon.entries = data.entries
            $('#calendar').fullCalendar('removeEvents')
            $('#calendar').fullCalendar('addEventSource', gon.entries)
          else
            $('#user-info-errors').html(data.errors)

          
@Profile = Profile
