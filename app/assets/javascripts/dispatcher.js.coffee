$ ->
  new Dispatcher()

  
class Dispatcher
  constructor: ->
    page = $('body').data('page')
    switch page
     	when 'profile:index'
      	new Profile()
      when 'login:signup', 'login:index'
      	new Login()