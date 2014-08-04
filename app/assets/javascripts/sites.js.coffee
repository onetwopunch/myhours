class SitesManager
  constructor: ->
    @bind_manage_sites()
    
  bind_manage_sites: ->
    @bind_add_site()
    @bind_back()
    @bind_site_items()
    @clear_new()
    
  bind_add_site: ->
    _this = @
    $('#btn-add-site').click () ->
      $('#view-all-sites').hide()
      $('#view-new-site').show()
      _this.bind_new() unless $('#btn-save-site').hasClass('bound')
      _this.bind_back()
  
  bind_back: ->  
    _this = @
    $('.btn-back-all-sites').click () ->
      $('#view-new-site').hide()
      $('#view-edit-site').hide()
      $('#view-all-sites').show()
      _this.bind_manage_sites()
  
  bind_site_items: ->  
    _this = @
    $('.site-item').click () ->
      site_id = $(this).data('site')
      $.post 'profile/get_site',
        site_id: site_id
        (data) ->
          if data.success == true
            $('#view-edit-site').html(data.html)
            $('#view-all-sites').hide()
            $('#view-edit-site').show()
            _this.bind_edit()
            _this.bind_back()
          else
            $('#site-modal-error').html('Site could not be found.')
    
  bind_edit: -> 
    _this = @
    $('.delete-site').click () ->
      $.post '/profile/delete_site',
        site_id: $('#site-hidden').data('site')
        (data) ->
          if data.success == true
            $('#view-all-sites').html(data.html)
            $('#view-edit-site').hide()
            $('#view-all-sites').show()
            _this.bind_manage_sites()
          else
            $('#site-modal-error').html('Site could not be deleted. Please try again.')
    $('#btn-edit-site').click () ->
      $.post '/profile/edit_site',
        site_id: $('#site-hidden').data('site')
        site_name: $('#edit_site_name').val()
        site_address: $('#edit_site_address').val()
        site_phone: $('#edit_site_phone').val()
        sup_name: $('#edit_sup_name').val()
        sup_phone: $('#edit_sup_phone').val()
        sup_email: $('#edit_sup_email').val()
        sup_license_type: $('#edit_sup_license_type').val()
        sup_license_state: $('#edit_sup_license_state').val()
        sup_license_number: $('#edit_sup_license_number').val()
        (data) ->
          if data.success == true
            $('#view-all-sites').html(data.html)
            $('#view-edit-site').hide()
            $('#view-all-sites').show()
            _this.bind_manage_sites()
          else
            $('#site-modal-error').html('Site could not be saved. Please try again.')
    
  clear_new: ->
    $('#site_name').val('')
    $('#site_address').val('')
    $('#site_phone').val('')
    $('#sup_name').val('')
    $('#sup_phone').val('')
    $('#sup_email').val('')
    $('#sup_license_type').val('')
    $('#sup_license_state').val('')
    $('#sup_license_number').val('')

  bind_new: -> 
    _this = @
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
            $('#btn-save-site').addClass('bound')
            _this.bind_manage_sites()
          else
            $('#site-modal-error').html('Site could not be saved. Please try again.')
            
@SitesManager = SitesManager