# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

class Login
  constructor: ->
    console.log 'Login JS loaded'
    ###
    RegEx
    ###
    # emailRegEx = new RegExp("^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$", "i")
    emailRegEx = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
    passwordRegEx = new RegExp(/.{8,40}/)

    inputs = []
    passwords = []
    email = null
    err_pass_len    = "Password needs to be greater than 8 characters."
    err_non_match   = "Passwords must match"
    err_email       = "Email is invalid. ex.: username@domain.com"
    err_user_exists = "You're already in our system. Did you forget your password? "
    err_user_exists += "<a href = '/login/forgot'>Forgot</a>"
    err_user_not_exists = "What are you trying to pull? You're not a user!"

    hasErrorMessage = (element) ->
      return $(element).html() and $(element).html().length() > 0

    addErrorStyle = (element) ->
      $(element).addClass('error-field')

    removeErrorStyle = (element) ->
      $(element).removeClass('error-field')

    addErrorMessage = (element, message) ->
      $(element).html(message)

    removeErrorMessage = (element) ->
      $(element).html('')

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
      validateEmail(email)

    ###
    Forgotton Email onblur validation
    ###
    f_email = $('#forgot_user_email')
    f_email.blur () -> 
      validateUserExists(f_email, true)


    ###
    Signup submit callback
    ###
    $('#signup').submit (event) -> 
      validateUserExists(email, false)
      val = validateForm()
      if not user_is_new
        event.preventDefault()
        addErrorStyle(email)
        addErrorMessage(email_tag, err_user_exists)
        return false
      else if not val
        event.preventDefault()
      else
        return true
    ###
    Forgot password submit callback
    This is what is submitted when the user enters
    the email before the mailer is sent
    ###
    $('#forgot-email-form').submit (event) ->
      validateUserExists(f_email, true)
      if user_is_new
        event.preventDefault()
        return false
      else
        return true
    # This is called when the user follows the link in their email 
    # to change_password. They must have a valid new password.
    $('#change-email-form').submit (event) ->
      if validatePassword(password, false) && validateMatchingPasswords(password, rep_pass)
        return true
      else
        event.preventDefault()
        return false

    email_tag = '#err-email'
    pass_tag = '#err-pass'
    rep_pass_tag = '#err-match'
    user_is_new = true

    validateForm = () ->
      a = validateEmail(email)
      b = validatePassword(password, false)
      c = validateMatchingPasswords(password, rep_pass)
      d = user_is_new
      return a and b and c and d

    validateMatchingPasswords = (p1, p2) ->
      passes = true
      console.log('Match func')
      # console.log($(p1).val())
      # console.log($(p2).val())
      if validatePassword(p2, true)
        if p1.val() == p2.val()  
          console.log "2nd password is valid and passwords match"
          removeErrorStyle(p1)
          removeErrorStyle(p2)
          removeErrorMessage(pass_tag)
          removeErrorMessage(rep_pass_tag)
        else
          console.log "2nd password is valid but passwords don't match"
          passes = false
          addErrorStyle(p2)
          addErrorMessage(rep_pass_tag, err_non_match)
      else
        console.log "2nd password is invalid"
        addErrorStyle(p2)
        addErrorMessage(rep_pass_tag, err_pass_len)
        passes = false
      return passes

    validatePassword = (password, isMatch) ->
      passes = true
      console.log('Password func')
      # console.log($(password).val())
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
      console.log('Validating email')
      console.log($(email).val())
      if not emailRegEx.test($(email).val())
        console.log 'invalid email'
        passes = false
        console.log 'adding error style to ' 
        console.log email
        addErrorStyle(email)
        addErrorMessage(email_tag, err_email)
      else
        console.log 'valid email'
        passes = true
        removeErrorStyle(email)
        removeErrorMessage(email_tag)
      if passes
        validateUserExists(email, false)
      return passes

    validateUserExists = (email, we_want_user_to_exist) ->
      user_exists = false
      console.log "we_want_user_to_exist: "+we_want_user_to_exist
      $.ajax '/login/check_email_exists',
        type: 'POST'
        data: { email: $(email).val() }
        dataType: 'json'
        async: false
        error: (jqXHR, textStatus, errorThrown) ->
          alert("<b>Oops!</b><br><p>There was a server error validating your email:</p>" + errorThrown)
        success: (data, textStatus, jqXHR) -> 
          console.log "Request successful"
          user_exists = (data['response'] == "user_exists")
          console.log "Request user_exists?: " + user_exists
        complete: (jqXHR, textStatus) ->
          console.log "Request complete"
          if we_want_user_to_exist
            console.log "we_want_user_to_exist"
            if user_exists
              console.log "Complete user_exists true"
              user_is_new = false
              removeErrorStyle(email)
              removeErrorMessage(email_tag)
            else
              console.log "Complete user_exists false"
              addErrorStyle(email)
              addErrorMessage(email_tag, err_user_not_exists)
              user_is_new = true            
          else
            console.log "we_dont_want_user_to_exist"
            if user_exists
              console.log "Complete user_exists true"
              user_is_new = false
              addErrorStyle(email)
              addErrorMessage(email_tag, err_user_exists)
            else
              console.log "Complete user_exists false"
              user_is_new = true
              removeErrorStyle(email)
              removeErrorMessage(email_tag)

@Login = Login




