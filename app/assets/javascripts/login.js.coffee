# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  ###
  RegEx
  ###
  emailRegEx = new RegExp("^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$", "i")
  passwordRegEx = new RegExp(/.{8,40}/)

  inputs = []
  passwords = []
  email = null
  err_pass_len    = "Password needs to be greater than 8 characters."
  err_non_match   = "Passwords must match"
  err_email       = "Email is invalid. ex.: username@domain.com"
  err_user_exists = "You're already in our system. Did you forget your password? "
  err_user_exists += "<a href = '/login/forgot'>Forgot</a>"

  ###
  Passwords onblur validation
  ###
  password = $('#user_password')
  password.blur () ->
    validatePassword(password, false)

  rep_pass = $('#rep_pass')
  rep_pass.blur () -> 
    validateMatchingPasswords(password, rep_pass)

  ###
  Email onblur validation
  ###
  email = $('#user_email')
  email.blur () -> 
    validateEmail(email, emailRegEx)
  
  ###
  Submit callback
  ###
  $('#signup').submit (event) -> 
    val = validateForm()
    if not val
      event.preventDefault()
      return false
    else
      return true
  
  email_tag = '#err-email'
  pass_tag = '#err-pass'
  rep_pass_tag = '#err-match'
  user_is_new = true

  validateForm = () ->
    return validateEmail(email) &&
      validatePassword(password, false) &&
      validateMatchingPasswords(password, rep_pass) &&
      user_is_new

  validateMatchingPasswords = (p1, p2) ->
    passes = true
    console.log('Match func')
    console.log($(p1).val())
    console.log($(p2).val())
    if validatePassword(p2, true)
      if p1.val() == p2.val()  
        removeErrorStyle(p1)
        removeErrorStyle(p2)
        removeErrorMessage(pass_tag)
        removeErrorMessage(rep_pass_tag)
      else
        passes = false
        addErrorStyle(p2)
        addErrorMessage(rep_pass_tag, err_non_match)
    else
      addErrorStyle(p2)
      addErrorMessage(rep_pass_tag, err_pass_len)
      passes = false
    return passes

  validatePassword = (password, isMatch) ->
    passes = true
    console.log('Password func')
    console.log($(password).val())
    if passwordRegEx.test($(password).val())
      removeErrorStyle(password)
      removeErrorMessage(pass_tag)
    else
      passes = false
      addErrorStyle(password)
      if isMatch
        addErrorMessage(rep_pass_tag, err_pass_len)  
      else 
        addErrorMessage(pass_tag, err_pass_len)
    return passes
    
  validateEmail = (email) ->
    passes = true
    console.log('Email func')
    console.log($(email).val())
    if not emailRegEx.test($(email).val())
      passes = false
      addErrorStyle(email)
      addErrorMessage(email_tag, err_email)
    else
      removeErrorStyle(email)
      removeErrorMessage(email_tag)
    validateUserExists(email)
    return passes

  validateUserExists = (email) ->
    result = false
    $.ajax '/login/check_email_exists',
      type: 'POST'
      data: { email: $(email).val() }
      dataType: 'json'
      async: false
      error: (jqXHR, textStatus, errorThrown) ->
        alert("<b>Oops!</b><br><p>There was a server error validating your email:</p>" + errorThrown)
      success: (data, textStatus, jqXHR) -> 
        console.log "Request successful"
        result = (data['response'] == "user_exists")
        console.log "Request user_exists?: " + result
      complete: (jqXHR, textStatus) ->
        console.log "Request complete"
        if not result
          console.log "Complete result true"
          user_is_new = true
        else
          console.log "Complete result false"
          user_is_new = false
          addErrorStyle(email)
          addErrorMessage(email_tag, err_user_exists)
  

  
  ###
  Error Styling, I changed the border of the input and put an error message within a span in the label of the same input, it's opt to you.
  ###
  addErrorStyle = (element) ->
    $(element).addClass('error-field')

  removeErrorStyle = (element) ->
    $(element).removeClass('error-field')

  addErrorMessage = (element, message) ->
    $(element).html(message)

  removeErrorMessage = (element) ->
    $(element).html('')
    
