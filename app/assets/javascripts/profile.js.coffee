class Profile
  constructor: ->
    if gon.new_user == true
      $('#user-info-modal').modal('show')
    $('.date-picker').datepicker()
    $('#calendar').fullCalendar({
      	height: 500,
      	theme: true,
      	dayClick: @day_click,
      	events: gon.entries
      })
    @bind_user_details_submit()
    @bind_create_entry()
    @bind_manage_sites()
    
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
        date: $('#entry_date').val()
        site: $('#entry_site').val()
        (data) ->
          if data.success == true
            console.log data
            gon.entries.push(data.entry)
            $('#calendar').fullCalendar('refetchEvents')
          $('#entry-form-modal').modal('hide')
      
  
  bind_user_details_submit: ->
    $('.user-info-submit').click () ->
      $(this).parent().parent().find('form').submit()
  
  bind_manage_sites: ->
    
    $('#btn-add-site').click () ->
      $('#view-all-sites').hide()
      $('#view-new-site').show()
    
    $('#btn-back-all-sites').click () ->
      $('#view-new-site').hide()
      $('#view-all-sites').show()
    
    $('#btn-save-site').click () ->
      $.post '/profile/add_site',
        site_name: $('#site_name').val()
        site_address: $('#site_address').val()
        site_phone: $('#site_phone').val()
        sup_name: $('#sup_name').val()
        sup_phone: $('#sup_phone').val()
        sup_email: $('#sup_email').val()
        sup_license_type: $('#sup_license_type').val()
        sup_license_state: $('#sup_license_state').val()
        sup_license_number: $('#sup_license_number').val()
        (data) ->
          if data.success == true
            $('#view-all-sites').html(data.html)
            $('#view-new-site').hide()
            $('#view-all-sites').show()
          else
            $('#site-modal-error').html('Site could not be saved. Please try again.')
  
  
  
@Profile = Profile